use davey::{DaveSession, DAVE_PROTOCOL_VERSION};
use rustler::{Atom, Binary, Encoder, Env, Error, NewBinary, NifResult, ResourceArc, Term};
use std::{
    fmt::Display,
    num::NonZeroU16,
    sync::{Mutex, MutexGuard},
};

pub mod types;

rustler::init!("Elixir.Dave");

mod atoms {
    rustler::atoms! {
        ok,
        error,
    }
}

struct DaveSessionResource(Mutex<DaveSession>);

#[rustler::resource_impl]
impl rustler::Resource for DaveSessionResource {}

fn lock_session<'a>(
    session: &'a ResourceArc<DaveSessionResource>,
) -> NifResult<MutexGuard<'a, DaveSession>> {
    session.0.lock().map_err(raise_error)
}

fn raise_error(msg: impl Display) -> Error {
    Error::RaiseTerm(Box::new(msg.to_string()))
}

fn erl_binary<'a>(env: Env<'a>, bytes: &[u8]) -> Binary<'a> {
    let mut binary = NewBinary::new(env, bytes.len());
    binary.as_mut_slice().copy_from_slice(bytes);
    binary.into()
}

#[rustler::nif]
fn max_protocol_version() -> u16 {
    DAVE_PROTOCOL_VERSION
}

#[rustler::nif(schedule = "DirtyCpu")]
fn new_session(
    protocol_version: u16,
    user_id: u64,
    channel_id: u64,
) -> NifResult<ResourceArc<DaveSessionResource>> {
    let protocol_version = NonZeroU16::new(protocol_version).ok_or_else(|| Error::BadArg)?;

    DaveSession::new(protocol_version, user_id, channel_id, None)
        .map(|session| ResourceArc::new(DaveSessionResource(Mutex::new(session))))
        .map_err(raise_error)
}

#[rustler::nif(schedule = "DirtyCpu")]
fn get_serialized_key_package<'a>(
    env: Env<'a>,
    session: ResourceArc<DaveSessionResource>,
) -> NifResult<Binary<'a>> {
    let mut session = lock_session(&session)?;

    session
        .create_key_package()
        .map(|bytes| erl_binary(env, &bytes))
        .map_err(raise_error)
}

#[rustler::nif(schedule = "DirtyCpu")]
fn reinit(
    session: ResourceArc<DaveSessionResource>,
    protocol_version: u16,
    user_id: u64,
    channel_id: u64,
) -> NifResult<Atom> {
    let protocol_version = NonZeroU16::new(protocol_version).ok_or_else(|| Error::BadArg)?;
    let mut session = lock_session(&session)?;

    session
        .reinit(protocol_version, user_id, channel_id, None)
        .map(|_| atoms::ok())
        .map_err(raise_error)
}

#[rustler::nif(schedule = "DirtyCpu")]
fn set_external_sender(
    session: ResourceArc<DaveSessionResource>,
    sender: Binary,
) -> NifResult<Atom> {
    let mut session = lock_session(&session)?;

    session
        .set_external_sender(sender.as_slice())
        .map(|_| atoms::ok())
        .map_err(raise_error)
}

#[rustler::nif(schedule = "DirtyCpu")]
fn process_proposals<'a>(
    env: Env<'a>,
    session: ResourceArc<DaveSessionResource>,
    operation_type: types::ProposalsOperationType,
    proposals: Binary,
    user_ids: Option<Vec<u64>>,
) -> NifResult<Term<'a>> {
    let mut session = lock_session(&session)?;

    let op_type = operation_type.into();

    Ok(
        match session.process_proposals(op_type, proposals.as_slice(), user_ids.as_deref()) {
            Ok(opt_cw) => opt_cw
                .map(|cw| {
                    (
                        Some(erl_binary(env, &cw.commit)),
                        cw.welcome.map(|w| erl_binary(env, &w)),
                    )
                })
                .unwrap_or((None, None))
                .encode(env),
            Err(_) => atoms::error().encode(env),
        },
    )
}

#[rustler::nif(schedule = "DirtyCpu")]
fn process_commit(session: ResourceArc<DaveSessionResource>, commit: Binary) -> NifResult<Atom> {
    let mut session = lock_session(&session)?;

    Ok(match session.process_commit(commit.as_slice()) {
        Ok(_) => atoms::ok(),
        Err(_) => atoms::error(),
    })
}

#[rustler::nif(schedule = "DirtyCpu")]
fn process_welcome(session: ResourceArc<DaveSessionResource>, welcome: Binary) -> NifResult<Atom> {
    let mut session = lock_session(&session)?;

    Ok(match session.process_welcome(welcome.as_slice()) {
        Ok(_) => atoms::ok(),
        Err(_) => atoms::error(),
    })
}

#[rustler::nif(schedule = "DirtyCpu")]
fn encrypt<'a>(
    env: Env<'a>,
    session: ResourceArc<DaveSessionResource>,
    media_type: types::MediaType,
    codec: types::Codec,
    packet: Binary,
) -> NifResult<Term<'a>> {
    let mut session = lock_session(&session)?;

    let media_type = media_type.into();
    let codec = codec.into();

    Ok(
        match session.encrypt(media_type, codec, packet.as_slice()) {
            Ok(encrypted) => erl_binary(env, &encrypted).encode(env),
            Err(_) => atoms::error().encode(env),
        },
    )
}

#[rustler::nif(schedule = "DirtyCpu")]
fn decrypt<'a>(
    env: Env<'a>,
    session: ResourceArc<DaveSessionResource>,
    user_id: u64,
    media_type: types::MediaType,
    packet: Binary,
) -> NifResult<Term<'a>> {
    let mut session = lock_session(&session)?;

    let media_type = media_type.into();

    Ok(
        match session.decrypt(user_id, media_type, packet.as_slice()) {
            Ok(decrypted) => erl_binary(env, &decrypted).encode(env),
            Err(_) => atoms::error().encode(env),
        },
    )
}

#[rustler::nif(schedule = "DirtyCpu")]
fn set_passthrough_mode(
    session: ResourceArc<DaveSessionResource>,
    passthrough: bool,
) -> NifResult<Atom> {
    let mut session = lock_session(&session)?;

    session.set_passthrough_mode(passthrough, None);

    Ok(atoms::ok())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn reset(session: ResourceArc<DaveSessionResource>) -> NifResult<Atom> {
    let mut session = lock_session(&session)?;

    Ok(match session.reset() {
        Ok(_) => atoms::ok(),
        Err(_) => atoms::error(),
    })
}

#[rustler::nif(name = "ready?", schedule = "DirtyCpu")]
fn is_ready(session: ResourceArc<DaveSessionResource>) -> NifResult<bool> {
    let session = lock_session(&session)?;

    Ok(session.is_ready())
}

#[rustler::nif(name = "can_passthrough?", schedule = "DirtyCpu")]
fn can_passthrough(session: ResourceArc<DaveSessionResource>, user_id: u64) -> NifResult<bool> {
    let session = lock_session(&session)?;

    Ok(session.can_passthrough(user_id))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn epoch(session: ResourceArc<DaveSessionResource>) -> NifResult<u64> {
    let session = lock_session(&session)?;

    match session.epoch() {
        Some(epoch) => Ok(epoch.as_u64()),
        None => Ok(0),
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
fn status(session: ResourceArc<DaveSessionResource>) -> NifResult<types::SessionStatus> {
    let session = lock_session(&session)?;

    Ok(session.status().into())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn protocol_version(session: ResourceArc<DaveSessionResource>) -> NifResult<u16> {
    let session = lock_session(&session)?;

    Ok(session.protocol_version().get())
}
