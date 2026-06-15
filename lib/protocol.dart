/// PLC wire protocol. The associated [wireName] is the value passed to
/// the native `plc_tag_create` attribute string.
enum Protocol {
  /// Allen-Bradley flavour of EtherNet/IP.
  abEip('ab_eip'),

  /// Modbus TCP, used by many PLCs.
  modbusTcp('modbus_tcp');

  const Protocol(this.wireName);

  /// The string written into the `protocol=` attribute when creating a tag.
  final String wireName;
}
