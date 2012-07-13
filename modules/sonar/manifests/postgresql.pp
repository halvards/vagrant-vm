class sonar::postgresql {
  include postgresql::server

  $sonar_version = '3.1.1'
  $sonar_conf_file = "/opt/sonar-${sonar_version}/conf/sonar.properties"

  postgresql::role { 'create-postgresql-role-sonar':
    role => 'sonar',
  }

  postgresql::database { 'create-postgresql-database-sonar':
    database => 'sonar',
  }

  line::commentout { 'disable-sonar-derby-database':
    line => 'sonar.jdbc.url:\s+jdbc:derby:\/\/localhost:1527\/sonar;create=true',
    file => $sonar_conf_file,
  }

  line::uncomment { 'enable-sonar-postgresql-database':
    line => 'sonar.jdbc.url:\s+jdbc:postgresql:\/\/localhost\/sonar',
    file => $sonar_conf_file,
  }

  line::uncomment { 'select-sonar-postgresql-jdbc-driver':
    line => 'org.postgresql.Driver',
    file => $sonar_conf_file,
  }

  line::uncomment { 'enable-sonar-database-validation-query':
    line => 'sonar.jdbc.validationQuery:\s+select 1',
    file => $sonar_conf_file,
  }
}

