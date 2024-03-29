class VehiculosDB {
  static const String vehiculosTableSql = 'CREATE TABLE Vehiculos('
      ' idVehiculo TEXT PRIMARY KEY,'
      ' tipoUnidad TEXT,'
      ' tipoInspeccion TEXT,'
      ' carroceriaVehiculo TEXT,'
      ' placaVehiculo TEXT,'
      ' rucVehiculo TEXT,'
      ' razonSocialVehiculo TEXT,'
      ' partidaVehiculo TEXT,'
      ' oficinaVehiculo TEXT,'
      ' marcaVehiculo TEXT,'
      ' modeloVehiculo TEXT,'
      ' yearVehiculo TEXT,'
      ' serieVehiculo TEXT,'
      ' motorVehiculo TEXT,'
      ' combustibleVehiculo TEXT,'
      ' potenciaMotorVehiculo TEXT,'
      ' estadoInspeccionVehiculo TEXT,'
      ' imagenVehiculo TEXT,'
      ' color1 TEXT,'
      ' color2 TEXT,'
      ' cargaUtil TEXT,'
      ' estadoVehiculo TEXT)';

  static const String peronasTableSql = 'CREATE TABLE Personas('
      ' idPerson TEXT PRIMARY KEY,'
      ' nombrePerson TEXT,'
      ' dniPerson TEXT,'
      ' idCargo TEXT)';

  // static const String categoriasInspeccionTableSql = 'CREATE TABLE CategoriasInspeccion('
  //     ' idCatInspeccion TEXT PRIMARY KEY,'
  //     ' tipoUnidad TEXT,'
  //     ' tipoInspeccion TEXT,'
  //     ' descripcionCatInspeccion TEXT,'
  //     ' estadoCatInspeccion TEXT)';
  static const String categoriasInspeccionVehiculoTableSql = 'CREATE TABLE CategoriasInspeccionVehiculo('
      ' id TEXT PRIMARY KEY,'
      ' idCatInspeccion TEXT,'
      ' idVehiculo TEXT,'
      ' tipoUnidad TEXT,'
      ' tipoInspeccion TEXT,'
      ' descripcionCatInspeccion TEXT,'
      ' estadoCatInspeccion TEXT)';

  static const String itemInspeccionTableSql = 'CREATE TABLE ItemInspeccion('
      ' id TEXT PRIMARY KEY,'
      ' idItemInspeccion TEXT,'
      ' idCatInspeccion TEXT,'
      ' idVehiculo TEXT,'
      ' conteoItemInspeccion TEXT,'
      ' descripcionItemInspeccion TEXT,'
      ' estadoMantenimientoItemInspeccion TEXT,'
      ' estadoItemInspeccion TEXT)';
}
