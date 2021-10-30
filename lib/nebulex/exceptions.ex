defmodule Nebulex.RegistryLookupError do
  @moduledoc """
  Raised at runtime when the cache was not started or it does not exist.
  """
  defexception [:message, :name]

  def exception(opts) do
    name = Keyword.fetch!(opts, :name)

    msg =
      "could not lookup Nebulex cache #{inspect(name)} because it was " <>
        "not started or it does not exist"

    %__MODULE__{message: msg, name: name}
  end
end

defmodule Nebulex.KeyAlreadyExistsError do
  @moduledoc """
  Raised at runtime when a key already exists in cache.
  """
  defexception [:key, :cache]

  @impl true
  def message(%{key: key, cache: cache}) do
    "key #{inspect(key)} already exists in cache #{inspect(cache)}"
  end
end

defmodule Nebulex.QueryError do
  @moduledoc """
  Raised at runtime when the query is invalid.
  """
  defexception [:message]

  def exception(opts) do
    message = Keyword.fetch!(opts, :message)
    query = Keyword.fetch!(opts, :query)

    message = """
    #{message} in query:

    #{inspect(query, pretty: true)}
    """

    %__MODULE__{message: message}
  end
end

defmodule Nebulex.RPCMultiCallError do
  @moduledoc """
  Raised at runtime when a RPC multi_call error occurs.
  """
  defexception [:message]

  def exception(opts) do
    action = Keyword.fetch!(opts, :action)
    errors = Keyword.fetch!(opts, :errors)
    responses = Keyword.fetch!(opts, :responses)

    message = """
    RPC error executing action: #{action}

    Responses:

    #{inspect(responses, pretty: true)}

    Errors:

    #{inspect(errors, pretty: true)}
    """

    %__MODULE__{message: message}
  end
end

defmodule Nebulex.RPCError do
  @moduledoc """
  Raised at runtime when a RPC error occurs.
  """

  @type t :: %__MODULE__{reason: atom, node: node}

  defexception [:reason, :node]

  @impl true
  def message(%__MODULE__{reason: reason, node: node}) do
    format_reason(reason, node)
  end

  # :erpc.call/5 doesn't format error messages.
  defp format_reason({:erpc, _} = reason, node) do
    """
    The RPC operation failed on node #{inspect(node)} with reason:

    #{inspect(reason)}

    See :erpc.call/5 for more information about the error reasons.
    """
  end
end
