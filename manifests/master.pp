#install jenkins as master

include jenkins

include masterconfig

exec { 'waitonmaster':
  command => 'sleep 60',
  path    => ['/bin'],
}

exec { 'addjob1':
  command => "curl -s -XPOST 'http://localhost:8080/createItem?name=sample-maven-artifactory-job' --data-binary @maven-sample-job.xml -H 'Content-Type:text/xml' ",
  path    => ['/usr/bin', '/bin'],
  cwd     => '/opt/garage/modules/masterconfig/files',
}
exec { 'addjob2':
  command => "curl -s -XPOST 'http://localhost:8080/createItem?name=ci-build-pipeline-demo' --data-binary @ci-build-pipeline.xml -H 'Content-Type:text/xml' ",
  path    => ['/usr/bin', '/bin'],
  cwd     => '/opt/garage/modules/masterconfig/files',
}
exec { 'addjob3':
  command => "curl -s -XPOST 'http://localhost:8080/createItem?name=cd-pipeline-demo' --data-binary @cd-pipeline-demo.xml -H 'Content-Type:text/xml' ",
  path    => ['/usr/bin', '/bin'],
  cwd     => '/opt/garage/modules/masterconfig/files',
}

Class['jenkins'] -> Exec['waitonmaster'] -> Exec['addjob1'] -> Exec['addjob2'] -> Exec['addjob3'] -> Class['masterconfig']
