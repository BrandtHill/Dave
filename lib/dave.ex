defmodule Dave do
  targets = ["x86_64-unknown-freebsd" | RustlerPrecompiled.Config.default_targets()]

  @moduledoc """
  Functions for using the DAVE Protocol

  [Discord Audio & Video End-to-End Encryption (DAVE) Protocol Whitepaper](https://daveprotocol.com/)

  [The Rust crate `davey`](https://github.com/Snazzah/davey)

  RustlerPrecompiled will fetch the required files at compile time.

  The following OS's have binaries available:
  #{targets |> Enum.sort() |> Enum.map_join("\n", &"- `#{&1}`")}

  If you have some wackadoo OS or you prefer to build from source with your installed Rust toolchain,
  you can add Rustler to your project dependencies and set `FORCE_DAVE_BUILD=true`.

  ```elixir
  defp deps do
    [
      ...
      {:rustler, "~> 0.37", optional: true, runtime: false}
    ]
  end
  ```

  Minimum set of functions required to get Discord Voice working are implemented. `davey` has some other
  functionality that may be added later. Docs here are limited, so I would recommend looking at the DAVE whitepaper
  or nostrum source code for integration and usage details.
  """

  source_url = Mix.Project.config()[:source_url]
  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :dave,
    crate: "dave",
    base_url: "#{source_url}/releases/download/v#{version}",
    version: version,
    force_build: System.get_env("FORCE_DAVE_BUILD") in ~w[1 true yes y],
    targets: targets

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
