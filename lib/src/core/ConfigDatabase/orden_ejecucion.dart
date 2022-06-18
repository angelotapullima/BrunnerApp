class OrdenEjecucionDB {
  static const String clientesOETableSql = 'CREATE TABLE ClientesOE('
      ' idCliente TEXT PRIMARY KEY,'
      ' id TEXT,'
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
      ' idCliente TEXT,'
      ' establecimientoLugar TEXT,'
      ' idLugar TEXT)';

  static const String actividadesOETableSql = 'CREATE TABLE ActividadesOE('
      ' idDetallePeriodo TEXT PRIMARY KEY,'
      ' idCliente TEXT,'
      ' total TEXT,'
      ' nombreActividad TEXT,'
      ' descripcionDetallePeriodo TEXT,'
      ' cantDetallePeriodo TEXT,'
      ' umDetallePeriodo TEXT)';
}
