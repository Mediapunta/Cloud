apache/


EtendedStatus On
<Location /server-status>
  SetHandler server-status
  Order deny,allow
  Deny from all
  Allow from localhost
</Location>



2020-02-18 18:16:25 KST | CORE | WARN | (pkg/collector/python/datadog_agent.go:118 i    n LogMessage) | apache:a3e9de086a635087 | (apache.py:70) | Caught exception 503 Serv    er Error: Service Unavailable for url: http://localhost/server-status?auto
2020-02-18 18:16:25 KST | CORE | ERROR | (pkg/collector/runner/runner.go:292 in work    ) | Error running check apache: [{"message": "503 Server Error: Service Unavailable     for url: http://localhost/server-status?auto", "traceback": "Traceback (most recent     call last):\n  File \"/opt/datadog-agent/embedded/lib/python3.7/site-packages/datado    g_checks/base/checks/base.py\", line 678, in run\n    self.check(instance)\n  File \    "/opt/datadog-agent/embedded/lib/python3.7/site-packages/datadog_checks/apache/apach    e.py\", line 67, in check\n    r.raise_for_status()\n  File \"/opt/datadog-agent/emb    edded/lib/python3.7/site-packages/requests/models.py\", line 940, in raise_for_statu    s\n    raise HTTPError(http_error_msg, response=self)\nrequests.exceptions.HTTPError    : 503 Server Error: Service Unavailable for url: http://localhost/server-status?auto    \n"}]
