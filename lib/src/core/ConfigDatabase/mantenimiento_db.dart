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
}
