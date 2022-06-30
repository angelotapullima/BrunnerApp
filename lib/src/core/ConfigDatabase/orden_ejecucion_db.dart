class OrdenEjecucionDB {
  static const String clientesOETableSql = 'CREATE TABLE ClientesOE('
      ' idCliente TEXT PRIMARY KEY,'
      ' id TEXT,'
      ' logoCliente TEXT,'
      ' nombreCliente TEXT)';

  static const String contactosOETableSql = 'CREATE TABLE ContactosOE('
      ' idContacto TEXT PRIMARY KEY,'
      ' idCliente TEXT,'
      ' contactoCliente TEXT,'
      ' cargoCliente TEXT,'
      ' emailCliente TEXT,'
      ' telefonoCliente TEXT,'
      ' cipCliente TEXT)';

  static const String codigosOETableSql = 'CREATE TABLE CodigosOE('
      ' idCod TEXT PRIMARY KEY,'
      ' idCliente TEXT,'
      ' periodoCod TEXT)';

  static const String lugaresOETableSql = 'CREATE TABLE LugaresOE('
      ' idLugarEjecucion TEXT PRIMARY KEY,'
      ' idPeriodo TEXT,'
      ' establecimientoLugar TEXT,'
      ' idLugar TEXT)';

  static const String actividadesOETableSql = 'CREATE TABLE ActividadesOE('
      ' idDetallePeriodo TEXT PRIMARY KEY,'
      ' idPeriodo TEXT,'
      ' total TEXT,'
      ' nombreActividad TEXT,'
      ' descripcionDetallePeriodo TEXT,'
      ' cantDetallePeriodo TEXT,'
      ' umDetallePeriodo TEXT)';

  static const String ordenEjecucionTableSql = 'CREATE TABLE OrdenEjecucion('
      ' idOE TEXT PRIMARY KEY,'
      ' idCliente TEXT,'
      ' idEmpresa TEXT,'
      ' idDepartamento TEXT,'
      ' idSede TEXT,'
      ' numeroOE TEXT,'
      ' descripcionOE TEXT,'
      ' fechaOE TEXT,'
      ' cipRTOE TEXT,'
      ' rtOE TEXT,'
      ' contactoOE TEXT,'
      ' telefonoContactoOE TEXT,'
      ' emailContactoOE TEXT,'
      ' idUserCreacionOE TEXT,'
      ' fechaCreacionOE TEXT,'
      ' estadoOE TEXT,'
      ' mtOE TEXT,'
      ' idUserAprobacion TEXT,'
      ' fechaAprobacionOE TEXT,'
      ' enviadoFacturacion TEXT,'
      ' idLugarOE TEXT,'
      ' codigoPeriodo TEXT,'
      ' lugarPeriodo TEXT,'
      ' condicionOE TEXT)';

  static const String personalOETableSql = 'CREATE TABLE PersonalOE('
      ' idPersona TEXT PRIMARY KEY,'
      ' id TEXT,'
      ' nombre TEXT,'
      ' dni TEXT,'
      ' fechaPeriodo TEXT,'
      ' image TEXT,'
      ' idCargo TEXT,'
      ' cargo TEXT,'
      ' detalleCargo TEXT,'
      ' valueAsistencia TEXT,'
      ' asistenciaProyectada TEXT)';

  static const String unidadesOETableSql = 'CREATE TABLE UnidadesOE('
      ' idVehiculo TEXT PRIMARY KEY,'
      ' id TEXT,'
      ' placaVehiculo TEXT)';
}
