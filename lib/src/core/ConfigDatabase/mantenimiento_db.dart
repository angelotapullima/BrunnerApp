class MantenimientoDB {
  static const String checkItemInspeccionTableSql = 'CREATE TABLE CheckItemInspeccion('
      ' idCheckItemInsp TEXT PRIMARY KEY,'
      ' idCatInspeccion TEXT,'
      ' idItemInspeccion TEXT,'
      ' idVehiculo TEXT,'
      ' conteoCheckItemInsp TEXT,'
      ' descripcionCheckItemInsp TEXT,'
      ' estadoMantenimientoCheckItemInsp TEXT,'
      ' estadoCheckItemInsp TEXT,'
      ' valueCheckItemInsp TEXT,'
      ' ckeckItemHabilitado TEXT,'
      ' observacionCkeckItemInsp TEXT)';

  static const String inspeccionVehiculosTableSql = 'CREATE TABLE InspeccionVehiculos('
      ' idInspeccionVehiculo TEXT PRIMARY KEY,'
      ' fechaInspeccionVehiculo TEXT,'
      ' numeroInspeccionVehiculo TEXT,'
      ' estadoCheckInspeccionVehiculo TEXT,'
      ' placaVehiculo TEXT,'
      ' rucVehiculo TEXT,'
      ' razonSocialVehiculo TEXT,'
      ' idchofer TEXT,'
      ' nombreChofer TEXT,'
      ' nombreUsuario TEXT,'
      ' tipoUnidad TEXT)';
}
