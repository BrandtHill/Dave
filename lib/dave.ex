defmodule Dave do
  @moduledoc """
  DAVE
  """

  use Rustler, otp_app: :dave, crate: "dave"

  @type session :: reference()
  @type protocol_version :: pos_integer()
  @type commit_welcome :: {binary() | nil, binary() | nil}
  @type proposals_operation_type :: :append | :revoke
  @type media_type :: :audio | :video
  @type codec :: :unknown | :opus | :av1 | :vp8 | :vp9 | :h264 | :h265
  @type session_status :: :inactive | :pending | :awaiting_response | :active

  @spec max_protocol_version() :: protocol_version()
  def max_protocol_version(),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec new_session(protocol_version(), non_neg_integer(), non_neg_integer()) :: session()
  def new_session(_protocol_version, _user_id, _channel_id),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec get_serialized_key_package(session()) :: binary()
  def get_serialized_key_package(_session),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec reinit(session(), protocol_version(), non_neg_integer(), non_neg_integer()) :: :ok
  def reinit(_session, _protocol_version, _user_id, _channel_id),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec set_external_sender(session(), binary()) :: :ok
  def set_external_sender(_session, _sender),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec process_proposals(
          session(),
          proposals_operation_type(),
          binary(),
          [non_neg_integer()] | nil
        ) :: commit_welcome() | :error
  def process_proposals(_session, _operation_type, _proposals, _user_ids \\ nil),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec process_commit(session(), binary()) :: :ok | :error
  def process_commit(_session, _commit),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec process_welcome(session(), binary()) :: :ok | :error
  def process_welcome(_session, _welcome),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec encrypt(session(), media_type(), codec(), binary()) :: binary() | :error
  def encrypt(_session, _media_type \\ :audio, _codec \\ :opus, _packet),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec decrypt(session(), non_neg_integer(), media_type(), binary()) :: binary() | :error
  def decrypt(_session, _user_id, _media_type \\ :audio, _packet),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec set_passthrough_mode(session(), boolean()) :: :ok
  def set_passthrough_mode(_session, _passthrough?),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec reset(session()) :: :ok | :error
  def reset(_session),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec ready?(session()) :: boolean()
  def ready?(_session),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec can_passthrough?(session(), non_neg_integer()) :: boolean()
  def can_passthrough?(_session, _user_id),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec epoch(session()) :: non_neg_integer()
  def epoch(_session),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec status(session()) :: session_status()
  def status(_session),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec protocol_version(session()) :: protocol_version()
  def protocol_version(_session),
    do: :erlang.nif_error(:nif_not_loaded)
end
