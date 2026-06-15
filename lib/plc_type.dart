/// PLC family. The associated [wireName] is the value used in the
/// attribute string passed to the native `plc_tag_create`.
enum PlcType {
  /// Control Logix-class PLC. Synonyms: `lgx`, `logix`, `compactlogix`, `clgx`.
  controlLogix('controllogix'),

  /// PLC/5 PLC. Synonyms: `plc`.
  plc5('plc5'),

  /// SLC 500 PLC. Synonyms: `slc`.
  slc500('slc500'),

  /// Control Logix-class PLC speaking the PLC/5 protocol.
  /// Synonyms: `lgxpccc`, `logixpccc`, `lgx_pccc`, `lgx_plc5`.
  logixPccc('logixpccc'),

  /// Micro800-class PLC. Synonyms: `mlgx800`, `micrologix800`.
  micro800('micro800'),

  /// MicroLogix PLC. Synonyms: `mlgx`.
  microLogix('micrologix'),

  /// Omron PLC. Synonyms: `omron-nj`, `omron-nx`, `njnx`, `nx1p2`.
  omron('omron-njnx');

  const PlcType(this.wireName);

  /// The string written into the `plc=` attribute when creating a tag.
  final String wireName;
}
