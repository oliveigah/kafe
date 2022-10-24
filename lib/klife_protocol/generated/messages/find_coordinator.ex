# DO NOT EDIT THIS FILE MANUALLY  
# This module is automatically generated by running mix task generate_file
# every change must be done inside the mix task directly

defmodule KlifeProtocol.Messages.FindCoordinator do
  @moduledoc """
  Kafka protocol FindCoordinator message

  Request versions summary:   
  - Version 1 adds KeyType.
  - Version 2 is the same as version 1.
  - Version 3 is the first flexible version.
  - Version 4 adds support for batching via CoordinatorKeys (KIP-699)

  Response versions summary:
  - Version 1 adds throttle time and error messages.
  - Starting in version 2, on quota violation, brokers send out responses before throttling.
  - Version 3 is the first flexible version.
  - Version 4 adds support for batching via Coordinators (KIP-699)

  """

  alias KlifeProtocol.Deserializer
  alias KlifeProtocol.Serializer
  alias KlifeProtocol.Header

  @api_key 10
  @min_flexible_version_req 3
  @min_flexible_version_res 3

  @doc """
  Valid fields:

  - key: The coordinator key. (string | versions 0-3)
  - key_type: The coordinator key type. (Group, transaction, etc.) (int8 | versions 1+)
  - coordinator_keys: The coordinator keys. ([]string | versions 4+)

  """
  def serialize_request(%{headers: headers, content: content}, version) do
    headers
    |> Map.put(:request_api_key, @api_key)
    |> Map.put(:request_api_version, version)
    |> Header.serialize_request(req_header_version(version))
    |> then(&Serializer.execute(content, request_schema(version), &1))
  end

  @doc """
  Valid fields:

  - throttle_time_ms: The duration in milliseconds for which the request was throttled due to a quota violation, or zero if the request did not violate any quota. (int32 | versions 1+)
  - error_code: The error code, or 0 if there was no error. (int16 | versions 0-3)
  - error_message: The error message, or null if there was no error. (string | versions 1-3)
  - node_id: The node id. (int32 | versions 0-3)
  - host: The host name. (string | versions 0-3)
  - port: The port. (int32 | versions 0-3)
  - coordinators: Each coordinator result in the response ([]Coordinator | versions 4+)
      - key: The coordinator key. (string | versions 4+)
      - node_id: The node id. (int32 | versions 4+)
      - host: The host name. (string | versions 4+)
      - port: The port. (int32 | versions 4+)
      - error_code: The error code, or 0 if there was no error. (int16 | versions 4+)
      - error_message: The error message, or null if there was no error. (string | versions 4+)

  """
  def deserialize_response(data, version) do
    {headers, rest_data} = Header.deserialize_response(data, res_header_version(version))
    {content, <<>>} = Deserializer.execute(rest_data, response_schema(version))

    %{headers: headers, content: content}
  end

  defp req_header_version(msg_version),
    do: if(msg_version >= @min_flexible_version_req, do: 2, else: 1)

  defp res_header_version(msg_version),
    do: if(msg_version >= @min_flexible_version_res, do: 1, else: 0)

  defp request_schema(0), do: [key: {:string, %{is_nullable?: false}}]

  defp request_schema(1),
    do: [key: {:string, %{is_nullable?: false}}, key_type: {:int8, %{is_nullable?: false}}]

  defp request_schema(2),
    do: [key: {:string, %{is_nullable?: false}}, key_type: {:int8, %{is_nullable?: false}}]

  defp request_schema(3),
    do: [
      key: {:compact_string, %{is_nullable?: false}},
      key_type: {:int8, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(4),
    do: [
      key_type: {:int8, %{is_nullable?: false}},
      coordinator_keys: {{:compact_array, :compact_string}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp response_schema(0),
    do: [
      error_code: {:int16, %{is_nullable?: false}},
      node_id: {:int32, %{is_nullable?: false}},
      host: {:string, %{is_nullable?: false}},
      port: {:int32, %{is_nullable?: false}}
    ]

  defp response_schema(1),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      error_message: {:string, %{is_nullable?: true}},
      node_id: {:int32, %{is_nullable?: false}},
      host: {:string, %{is_nullable?: false}},
      port: {:int32, %{is_nullable?: false}}
    ]

  defp response_schema(2),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      error_message: {:string, %{is_nullable?: true}},
      node_id: {:int32, %{is_nullable?: false}},
      host: {:string, %{is_nullable?: false}},
      port: {:int32, %{is_nullable?: false}}
    ]

  defp response_schema(3),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      error_message: {:compact_string, %{is_nullable?: true}},
      node_id: {:int32, %{is_nullable?: false}},
      host: {:compact_string, %{is_nullable?: false}},
      port: {:int32, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(4),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      coordinators:
        {{:compact_array,
          [
            key: {:compact_string, %{is_nullable?: false}},
            node_id: {:int32, %{is_nullable?: false}},
            host: {:compact_string, %{is_nullable?: false}},
            port: {:int32, %{is_nullable?: false}},
            error_code: {:int16, %{is_nullable?: false}},
            error_message: {:compact_string, %{is_nullable?: true}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]
end