class LogisticaDB {
  static const String empresasTableSql = 'CREATE TABLE Empresas('
      ' idEmpresa TEXT PRIMARY KEY,'
      ' nombreEmpresa TEXT,'
      ' rucEmpresa TEXT,'
      ' direccionEmpresa TEXT,'
      ' departamentoEmpresa TEXT,'
      ' provinciaEmpresa TEXT,'
      ' distritoEmpresa TEXT,'
      ' estadoEmpresa TEXT)';

  static const String proveedoresTableSql = 'CREATE TABLE Proveedores('
      ' idProveedor TEXT PRIMARY KEY,'
      ' nombreProveedor TEXT,'
      ' rucProveedor TEXT,'
      ' direccionProveedor TEXT,'
      ' telefonoProveedor TEXT,'
      ' contactoProveedor TEXT,'
      ' emailProveedor TEXT,'
      ' clase1Proveedor TEXT,'
      ' clase2Proveedor TEXT,'
      ' clase3Proveedor TEXT,'
      ' clase4Proveedor TEXT,'
      ' clase5Proveedor TEXT,'
      ' clase6Proveedor TEXT,'
      ' banco1Proveedor TEXT,'
      ' banco2Proveedor TEXT,'
      ' banco3Proveedor TEXT,'
      ' estadoProveedor TEXT)';

  static const String ordenPedidoTableSql = 'CREATE TABLE OrdenPedido('
      ' idOP TEXT PRIMARY KEY,'
      ' numeroOP TEXT,'
      ' nombreEmpresa TEXT,'
      ' nombreSede TEXT,'
      ' idProveedor TEXT,'
      ' nombreProveedor TEXT,'
      ' monedaOP TEXT,'
      ' totalOP TEXT,'
      ' fechaOP TEXT,'
      ' nombrePerson TEXT,'
      ' surnamePerson TEXT,'
      ' surname2Person TEXT,'
      ' nombreApro TEXT,'
      ' surnameApro TEXT,'
      ' surname2Apro TEXT,'
      ' fechaCreacion TEXT,'
      ' estado TEXT,'
      ' departamento TEXT,'
      ' rendido TEXT)';

  static const String detalleOrdenPedidoTableSql = 'CREATE TABLE DetalleOrdenPedido('
      ' idDetalleOP TEXT PRIMARY KEY,'
      ' idOP TEXT,'
      ' idDetalleSI TEXT,'
      ' precioUnitario TEXT,'
      ' precioTotal TEXT,'
      ' idSI TEXT,'
      ' idRecurso TEXT,'
      ' idTipoRecurso TEXT,'
      ' descripcionSI TEXT,'
      ' umSI TEXT,'
      ' cantidadSI TEXT,'
      ' estadoSI TEXT,'
      ' atentidoSI TEXT,'
      ' cajaAlmacenSI TEXT,'
      ' tipoNombreRecurso TEXT,'
      ' nroSI TEXT,'
      ' logisticaNombreRecurso TEXT)';
}