use rustler::NifUnitEnum;
//use davey::{ProposalsOperationType, MediaType, Codec, SessionStatus};

#[derive(NifUnitEnum)]
pub enum ProposalsOperationType {
    Append,
    Revoke,
}

#[derive(NifUnitEnum)]
pub enum MediaType {
    Audio,
    Video,
}

#[derive(NifUnitEnum)]
pub enum Codec {
    Unknown,
    Opus,
    AV1,
    VP8,
    VP9,
    H264,
    H265,
}

#[derive(NifUnitEnum)]
pub enum SessionStatus {
    Inactive,
    Pending,
    AwaitingResponse,
    Active,
}

impl From<ProposalsOperationType> for davey::ProposalsOperationType {
    fn from(p: ProposalsOperationType) -> Self {
        match p {
            ProposalsOperationType::Append => davey::ProposalsOperationType::APPEND,
            ProposalsOperationType::Revoke => davey::ProposalsOperationType::REVOKE,
        }
    }
}

impl From<MediaType> for davey::MediaType {
    fn from(m: MediaType) -> Self {
        match m {
            MediaType::Audio => davey::MediaType::AUDIO,
            MediaType::Video => davey::MediaType::VIDEO,
        }
    }
}

impl From<Codec> for davey::Codec {
    fn from(c: Codec) -> Self {
        match c {
            Codec::Unknown => davey::Codec::UNKNOWN,
            Codec::Opus => davey::Codec::OPUS,
            Codec::AV1 => davey::Codec::AV1,
            Codec::VP8 => davey::Codec::VP8,
            Codec::VP9 => davey::Codec::VP9,
            Codec::H264 => davey::Codec::H264,
            Codec::H265 => davey::Codec::H265,
        }
    }
}

impl From<davey::SessionStatus> for SessionStatus {
    fn from(s: davey::SessionStatus) -> Self {
        match s {
            davey::SessionStatus::ACTIVE => SessionStatus::Active,
            davey::SessionStatus::AWAITING_RESPONSE => SessionStatus::AwaitingResponse,
            davey::SessionStatus::INACTIVE => SessionStatus::Inactive,
            davey::SessionStatus::PENDING => SessionStatus::Pending,
        }
    }
}
