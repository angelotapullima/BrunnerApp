class ModulosDB {
  static const String modulosTableSql = 'CREATE TABLE Modulos('
      ' idModulo TEXT PRIMARY KEY,'
      ' nombreModulo TEXT,'
      ' ordenModulo TEXT,'
      ' estadoModulo TEXT,'
      ' visibleAppModulo TEXT)';

  static const String submodulosTableSql = 'CREATE TABLE SubModulos('
      ' idSubModulo TEXT PRIMARY KEY,'
      ' idModulo TEXT,'
      ' nameSubModulo TEXT,'
      ' estadoSubModulo TEXT,'
      ' visibleAppSubModulo TEXT)';
}
