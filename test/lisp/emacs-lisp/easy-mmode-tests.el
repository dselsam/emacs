;;; easy-mmode-tests.el --- tests for easy-mmode.el  -*- lexical-binding: t -*-

;; Copyright (C) 2020 Free Software Foundation, Inc.

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Code:

(require 'ert)
(require 'easy-mmode)
(require 'message)

(ert-deftest easy-mmode--globalized-predicate ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (should (eq (easy-mmode--globalized-predicate-p nil) nil))
    (should (eq (easy-mmode--globalized-predicate-p t) t))
    (should (eq (easy-mmode--globalized-predicate-p '(not text-mode)) t))
    (should (eq (easy-mmode--globalized-predicate-p '(not text-mode)) t))
    (should (eq (easy-mmode--globalized-predicate-p '((not text-mode))) nil))
    (should (eq (easy-mmode--globalized-predicate-p '((not text-mode) t)) t))
    (should (eq (easy-mmode--globalized-predicate-p
                 '(c-mode emacs-lisp-mode))
                t))
    (mail-mode)
    (should (eq (easy-mmode--globalized-predicate-p
                 '(c-mode (not message-mode mail-mode) text-mode))
                nil))
    (text-mode)
    (should (eq (easy-mmode--globalized-predicate-p
                 '(c-mode (not message-mode mail-mode) text-mode))
                t))))

(ert-deftest easy-mmode--minor-mode ()
  (with-temp-buffer
    (define-minor-mode test-mode "A test.")
    (should (eq test-mode nil))
    (test-mode nil)
    (should (eq test-mode t))
    (test-mode -33)
    (should (eq test-mode nil))
    (test-mode 33)
    (should (eq test-mode t))
    (test-mode 'toggle)
    (should (eq test-mode nil))
    (test-mode 'toggle)
    (should (eq test-mode t))))

(provide 'easy-mmode-tests)

;;; easy-mmode-tests.el ends here
