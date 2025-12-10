;;; package --- Summary
;;; Commentary:

;;; Code:
(require 'sql)
(setq sql-postgres-login-params (append sql-postgres-login-params '(port)))
(provide '18-sql)
;;; 18-sql.el ends here
