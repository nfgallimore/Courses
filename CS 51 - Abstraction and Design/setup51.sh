update50

cd ~

curl -OL https://github.com/ocaml/ocaml/archive/4.01.tar.gz
tar -zxf 4.01.tar.gz
cd ocaml-4.01
./configure -prefix /usr
make world world.opt
sudo make install
sudo chmod 755 /usr/bin/{mkcamlp4,{o,}caml*}
sudo find /usr/lib/ocaml -type d -print0 | xargs -0 sudo chmod 755
sudo find /usr/lib/ocaml -type f -print0 | xargs -0 sudo chmod 644
sudo find /usr/lib/ocaml -type f -not -name "*.*" -print0 | xargs -0 sudo chmod 755
sudo chmod 644 /usr/man/man*/*
cd ..

curl -OL http://www.ocamlpro.com/pub/opam-full-1.1.0.tar.gz
tar -xzf opam-full-1.1.0.tar.gz
cd opam-full-1.1.0
sudo mv /etc/log50.d/clang ~
./configure -prefix /usr
make
sudo make install
sudo chmod 644 /usr/share/man/man1/opam*
sudo chmod 755 /usr/bin/opam*
sudo mv ~/clang /etc/log50.d/

echo -e "y\ny\ny\ny" | opam init
echo "y" | opam install core utop async yojson core_extended core_bench cohttp async_graphics cryptokit menhir

# eval `opam config env`


wget --no-check-certificate https://forge.ocamlcore.org/frs/download.php/1304/tuareg-2.0.7.tar.gz
tar -xzf tuareg-2.0.7.tar.gz
cd tuareg-2.0.7
make
mkdir -p ~/.elisp/tuareg-mode
mv -f * ~/.elisp/tuareg-mode/
touch ~/.emacs

tee -a ~/.emacs << EOF
;; -- Tuareg mode -----------------------------------------
;; Add Tuareg to your search path
(add-to-list
 'load-path
  ;; Change the path below to be wherever you've put your tuareg installation.
   (expand-file-name "~/.elisp/tuareg-mode"))
(require 'tuareg)
(require 'cl)
(setq auto-mode-alist
      (append '(("\\.ml[ily]?$" . tuareg-mode))
	      auto-mode-alist))

;; -- Tweaks for OS X -------------------------------------
;; Tweak for problem on OS X where Emacs.app doesn't run the right
;; init scripts when invoking a sub-shell
(cond
 ((eq window-system 'ns) ; macosx
   ;; Invoke login shells, so that .profile or .bash_profile is read
     (setq shell-command-switch "-lc")))

;; -- opam and utop setup --------------------------------
;; Setup environment variables using opam
(defun opam-vars ()
  (let* ((x (shell-command-to-string "opam config env"))
     (x (split-string x "\n"))
	 (x (remove-if (lambda (x) (equal x "")) x))
	     (x (mapcar (lambda (x) (split-string x ";")) x))
		 (x (mapcar (lambda (x) (car x)) x))
		     (x (mapcar (lambda (x) (split-string x "=")) x))
			 )
      x))
(dolist (var (opam-vars))
  (setenv (car var) (substring (cadr var) 1 -1)))
;; The following simpler alternative works as of opam 1.1
;; (dolist
;;    (var (car (read-from-string
;; 	       (shell-command-to-string "opam config env --sexp"))))
;;  (setenv (car var) (cadr var)))
;; Update the emacs path
(setq exec-path (split-string (getenv "PATH") path-separator))
;; Update the emacs load path
(push (concat (getenv "OCAML_TOPLEVEL_PATH")
          "/../../share/emacs/site-lisp") load-path)
;; Automatically load utop.el
(autoload 'utop "utop" "Toplevel for OCaml" t)
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
EOF

tee -a ~/.ocamlinit << EOF
#use "topfind";;
#thread;;
#camlp4o;;
#require "core.top";;
#require "core.syntax";;
open Core.Std
EOF

tee -a ~/.bashrc << EOF
# OPAM configuration
. /home/jharvard/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
EOF

cd ~

sed '/[oO][pP][aA][mM]/d' ~/.bash_profile > bash.tmp
mv bash.tmp .bash_profile

rm -rf tuareg-2.0.7* ocaml-4.01 4.01.tar.gz opam-full-1.1.0*
