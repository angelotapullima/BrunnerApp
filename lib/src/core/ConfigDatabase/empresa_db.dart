class EmpresaDB {
  static const String empresasTableSql = 'CREATE TABLE Empresas('
      ' idEmpresa TEXT PRIMARY KEY,'
      ' nombreEmpresa TEXT,'
      ' rucEmpresa TEXT,'
      ' direccionEmpresa TEXT,'
      ' departamentoEmpresa TEXT,'
      ' provinciaEmpresa TEXT,'
      ' distritoEmpresa TEXT,'
      ' estadoEmpresa TEXT)';

  static const String departamentoTableSql = 'CREATE TABLE Departamento('
      ' idDepartamento TEXT PRIMARY KEY,'
      ' nombreDepartamento TEXT,'
      ' estadoDepartamento TEXT)';

  static const String sedeTableSql = 'CREATE TABLE Sede('
      ' idSede TEXT PRIMARY KEY,'
      ' nombreSede TEXT,'
      ' estadoSede TEXT)';
}
