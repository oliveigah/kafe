# DO NOT EDIT THIS FILE MANUALLY  
# This module is automatically generated by running mix task generate_file
# every change must be done inside the mix task directly

defmodule KlifeProtocol.Messages.BrokerHeartbeat do
  @moduledoc """
  Kafka protocol BrokerHeartbeat message

  Request versions summary:   

  Response versions summary:

  """

  alias KlifeProtocol.Deserializer
  alias KlifeProtocol.Serializer
  alias KlifeProtocol.Header

  @api_key 63
  @min_flexible_version_req 0
  @min_flexible_version_res 0

  @doc """
  Valid fields:

  - broker_id: The broker ID. (int32 | versions 0+)
  - broker_epoch: The broker epoch. (int64 | versions 0+)
  - current_metadata_offset: The highest metadata offset which the broker has reached. (int64 | versions 0+)
  - want_fence: True if the broker wants to be fenced, false otherwise. (bool | versions 0+)
  - want_shut_down: True if the broker wants to be shut down, false otherwise. (bool | versions 0+)

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

  - throttle_time_ms: Duration in milliseconds for which the request was throttled due to a quota violation, or zero if the request did not violate any quota. (int32 | versions 0+)
  - error_code: The error code, or 0 if there was no error. (int16 | versions 0+)
  - is_caught_up: True if the broker has approximately caught up with the latest metadata. (bool | versions 0+)
  - is_fenced: True if the broker is fenced. (bool | versions 0+)
  - should_shut_down: True if the broker should proceed with its shutdown. (bool | versions 0+)

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

  defp request_schema(0),
    do: [
      broker_id: {:int32, %{is_nullable?: false}},
      broker_epoch: {:int64, %{is_nullable?: false}},
      current_metadata_offset: {:int64, %{is_nullable?: false}},
      want_fence: {:boolean, %{is_nullable?: false}},
      want_shut_down: {:boolean, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp response_schema(0),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      is_caught_up: {:boolean, %{is_nullable?: false}},
      is_fenced: {:boolean, %{is_nullable?: false}},
      should_shut_down: {:boolean, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]
end