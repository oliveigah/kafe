defmodule KlifeProtocol.Messages.JoinGroup do
  alias KlifeProtocol.Deserializer
  alias KlifeProtocol.Serializer
  alias KlifeProtocol.Header

  @api_key 11
  @min_flexible_version_req 6
  @min_flexible_version_res 6

  def serialize_request(input, version) do
    input
    |> Map.put(:request_api_key, @api_key)
    |> Map.put(:request_api_version, version)
    |> Header.serialize_request(req_header_version(version))
    |> then(&Serializer.execute(input, request_schema(version), &1))
  end

  def deserialize_response(data, version) do
    with {headers, rest_data} <- Header.deserialize_response(data, res_header_version(version)),
         {content, <<>>} <- Deserializer.execute(rest_data, response_schema(version)) do
      %{headers: headers, content: content}
    end
  end

  defp req_header_version(msg_version),
    do: if(msg_version >= @min_flexible_version_req, do: 2, else: 1)

  defp res_header_version(msg_version),
    do: if(msg_version >= @min_flexible_version_res, do: 1, else: 0)

  defp request_schema(0),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      session_timeout_ms: {:int32, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      protocol_type: {:string, %{is_nullable?: false}},
      protocols:
        {{:array,
          [name: {:string, %{is_nullable?: false}}, metadata: {:bytes, %{is_nullable?: false}}]},
         %{is_nullable?: false}}
    ]

  defp request_schema(1),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      session_timeout_ms: {:int32, %{is_nullable?: false}},
      rebalance_timeout_ms: {:int32, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      protocol_type: {:string, %{is_nullable?: false}},
      protocols:
        {{:array,
          [name: {:string, %{is_nullable?: false}}, metadata: {:bytes, %{is_nullable?: false}}]},
         %{is_nullable?: false}}
    ]

  defp request_schema(2),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      session_timeout_ms: {:int32, %{is_nullable?: false}},
      rebalance_timeout_ms: {:int32, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      protocol_type: {:string, %{is_nullable?: false}},
      protocols:
        {{:array,
          [name: {:string, %{is_nullable?: false}}, metadata: {:bytes, %{is_nullable?: false}}]},
         %{is_nullable?: false}}
    ]

  defp request_schema(3),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      session_timeout_ms: {:int32, %{is_nullable?: false}},
      rebalance_timeout_ms: {:int32, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      protocol_type: {:string, %{is_nullable?: false}},
      protocols:
        {{:array,
          [name: {:string, %{is_nullable?: false}}, metadata: {:bytes, %{is_nullable?: false}}]},
         %{is_nullable?: false}}
    ]

  defp request_schema(4),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      session_timeout_ms: {:int32, %{is_nullable?: false}},
      rebalance_timeout_ms: {:int32, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      protocol_type: {:string, %{is_nullable?: false}},
      protocols:
        {{:array,
          [name: {:string, %{is_nullable?: false}}, metadata: {:bytes, %{is_nullable?: false}}]},
         %{is_nullable?: false}}
    ]

  defp request_schema(5),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      session_timeout_ms: {:int32, %{is_nullable?: false}},
      rebalance_timeout_ms: {:int32, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      group_instance_id: {:string, %{is_nullable?: true}},
      protocol_type: {:string, %{is_nullable?: false}},
      protocols:
        {{:array,
          [name: {:string, %{is_nullable?: false}}, metadata: {:bytes, %{is_nullable?: false}}]},
         %{is_nullable?: false}}
    ]

  defp request_schema(6),
    do: [
      group_id: {:compact_string, %{is_nullable?: false}},
      session_timeout_ms: {:int32, %{is_nullable?: false}},
      rebalance_timeout_ms: {:int32, %{is_nullable?: false}},
      member_id: {:compact_string, %{is_nullable?: false}},
      group_instance_id: {:compact_string, %{is_nullable?: true}},
      protocol_type: {:compact_string, %{is_nullable?: false}},
      protocols:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            metadata: {:compact_bytes, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(7),
    do: [
      group_id: {:compact_string, %{is_nullable?: false}},
      session_timeout_ms: {:int32, %{is_nullable?: false}},
      rebalance_timeout_ms: {:int32, %{is_nullable?: false}},
      member_id: {:compact_string, %{is_nullable?: false}},
      group_instance_id: {:compact_string, %{is_nullable?: true}},
      protocol_type: {:compact_string, %{is_nullable?: false}},
      protocols:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            metadata: {:compact_bytes, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(8),
    do: [
      group_id: {:compact_string, %{is_nullable?: false}},
      session_timeout_ms: {:int32, %{is_nullable?: false}},
      rebalance_timeout_ms: {:int32, %{is_nullable?: false}},
      member_id: {:compact_string, %{is_nullable?: false}},
      group_instance_id: {:compact_string, %{is_nullable?: true}},
      protocol_type: {:compact_string, %{is_nullable?: false}},
      protocols:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            metadata: {:compact_bytes, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      reason: {:compact_string, %{is_nullable?: true}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(9),
    do: [
      group_id: {:compact_string, %{is_nullable?: false}},
      session_timeout_ms: {:int32, %{is_nullable?: false}},
      rebalance_timeout_ms: {:int32, %{is_nullable?: false}},
      member_id: {:compact_string, %{is_nullable?: false}},
      group_instance_id: {:compact_string, %{is_nullable?: true}},
      protocol_type: {:compact_string, %{is_nullable?: false}},
      protocols:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            metadata: {:compact_bytes, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      reason: {:compact_string, %{is_nullable?: true}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp response_schema(0),
    do: [
      error_code: {:int16, %{is_nullable?: false}},
      generation_id: {:int32, %{is_nullable?: false}},
      protocol_name: {:string, %{is_nullable?: false}},
      leader: {:string, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      members:
        {{:array,
          [
            member_id: {:string, %{is_nullable?: false}},
            metadata: {:bytes, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(1),
    do: [
      error_code: {:int16, %{is_nullable?: false}},
      generation_id: {:int32, %{is_nullable?: false}},
      protocol_name: {:string, %{is_nullable?: false}},
      leader: {:string, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      members:
        {{:array,
          [
            member_id: {:string, %{is_nullable?: false}},
            metadata: {:bytes, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(2),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      generation_id: {:int32, %{is_nullable?: false}},
      protocol_name: {:string, %{is_nullable?: false}},
      leader: {:string, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      members:
        {{:array,
          [
            member_id: {:string, %{is_nullable?: false}},
            metadata: {:bytes, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(3),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      generation_id: {:int32, %{is_nullable?: false}},
      protocol_name: {:string, %{is_nullable?: false}},
      leader: {:string, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      members:
        {{:array,
          [
            member_id: {:string, %{is_nullable?: false}},
            metadata: {:bytes, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(4),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      generation_id: {:int32, %{is_nullable?: false}},
      protocol_name: {:string, %{is_nullable?: false}},
      leader: {:string, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      members:
        {{:array,
          [
            member_id: {:string, %{is_nullable?: false}},
            metadata: {:bytes, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(5),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      generation_id: {:int32, %{is_nullable?: false}},
      protocol_name: {:string, %{is_nullable?: false}},
      leader: {:string, %{is_nullable?: false}},
      member_id: {:string, %{is_nullable?: false}},
      members:
        {{:array,
          [
            member_id: {:string, %{is_nullable?: false}},
            group_instance_id: {:string, %{is_nullable?: true}},
            metadata: {:bytes, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(6),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      generation_id: {:int32, %{is_nullable?: false}},
      protocol_name: {:compact_string, %{is_nullable?: false}},
      leader: {:compact_string, %{is_nullable?: false}},
      member_id: {:compact_string, %{is_nullable?: false}},
      members:
        {{:compact_array,
          [
            member_id: {:compact_string, %{is_nullable?: false}},
            group_instance_id: {:compact_string, %{is_nullable?: true}},
            metadata: {:compact_bytes, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(7),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      generation_id: {:int32, %{is_nullable?: false}},
      protocol_type: {:compact_string, %{is_nullable?: true}},
      protocol_name: {:compact_string, %{is_nullable?: true}},
      leader: {:compact_string, %{is_nullable?: false}},
      member_id: {:compact_string, %{is_nullable?: false}},
      members:
        {{:compact_array,
          [
            member_id: {:compact_string, %{is_nullable?: false}},
            group_instance_id: {:compact_string, %{is_nullable?: true}},
            metadata: {:compact_bytes, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(8),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      generation_id: {:int32, %{is_nullable?: false}},
      protocol_type: {:compact_string, %{is_nullable?: true}},
      protocol_name: {:compact_string, %{is_nullable?: true}},
      leader: {:compact_string, %{is_nullable?: false}},
      member_id: {:compact_string, %{is_nullable?: false}},
      members:
        {{:compact_array,
          [
            member_id: {:compact_string, %{is_nullable?: false}},
            group_instance_id: {:compact_string, %{is_nullable?: true}},
            metadata: {:compact_bytes, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(9),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      generation_id: {:int32, %{is_nullable?: false}},
      protocol_type: {:compact_string, %{is_nullable?: true}},
      protocol_name: {:compact_string, %{is_nullable?: true}},
      leader: {:compact_string, %{is_nullable?: false}},
      skip_assignment: {:boolean, %{is_nullable?: false}},
      member_id: {:compact_string, %{is_nullable?: false}},
      members:
        {{:compact_array,
          [
            member_id: {:compact_string, %{is_nullable?: false}},
            group_instance_id: {:compact_string, %{is_nullable?: true}},
            metadata: {:compact_bytes, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]
end