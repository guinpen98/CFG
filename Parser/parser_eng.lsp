(defun atom? (seq) (and (not (null seq)) (null (cdr seq))))
(defun head  (seq) (list (car seq))                       )
(defun tail  (seq) (cdr seq)                              )

(defun S? (x)
       (cond ((and (NP?  (head x)) (VP? (tail x))) (cons 'S  (list (NP?   (head x)) (VP? (tail x)))))    ; S=NP+VP?
             ((and (NP? (subseq x 0 2)) (VP? (cddr x)) (cons 'S  (list (NP? (subseq x 0 2)) (VP? (cddr x))))))    ; S=NP+VP?
             ((and (NP? (subseq x 0 3)) (VP? (cdddr x)) (cons 'S  (list (NP? (subseq x 0 3)) (VP? (cdddr x))))))    ; S=NP+VP?
             (T                                    NIL                                              )))  ; デフォルト

(defun NP? (x)
       (cond ((and (PRONPOS? (head x)) (N?  (tail x))) (cons 'NP (list (PRONPOS? (head x)) (N? (tail x)))))    ; NP=PRONPOS+N?
             ((and (ART?      (head x)) (N?  (tail x))) (cons 'NP (list (ART?      (head x)) (N? (tail x)))))    ; NP=ART+N?
             ((and (ADJ?      (head x)) (N?  (tail x))) (cons 'NP (list (ADJ?      (head x)) (N? (tail x)))))    ; NP=ADJ+N?
             ((PRON? (head x))                          (cons 'NP (list (PRON? (head x))))                  )    ; NP=PRON?
             ((N?    (head x))                          (cons 'NP (list (N?    (head x))))                  )    ; NP=N?
             ((and (ART? (head x)) (ADJ? (list (second x))) (N? (cddr x))) (cons 'NP (list (ART? (head x)) (ADJ? (list (second x))) (N? (cddr x))))) ; NP=ART+ADJ+N?
             (T                                         NIL                                                 )))  ; デフォルト

(defun VP? (x)
       (cond ((equal x nil) NIL)
             ((equal (tail x) nil) NIL)
             ((and (ADV? (head x)) (VT? (tail x))) (cons 'VP (list (ADV?  (head x)) (VT? (tail x)))))    ; VP=ADV+VT?
             ((and (VA?  (head x)) (VT? (tail x))) (cons 'VP (list (VA?   (head x)) (VT? (tail x)))))    ; VP=VA+VT?
             ((and (VI?  (head x)) (NP? (tail x))) (cons 'VP (list (VI?   (head x)) (NP? (tail x)))))    ; VP=VI+NP?
             ((and (VT?  (head x)) (NP? (tail x))) (cons 'VP (list (VT?   (head x)) (NP? (tail x)))))    ; VP=VT+NP?
             ((and (VP?  (head x)) (NP? (tail x))) (cons 'VP (list (VP?   (head x)) (NP? (tail x)))))    ; VP=VP+NP?
             ((and (VP?  (head x)) (VT? (tail x))) (cons 'VP (list (VP?   (head x)) (VT? (tail x)))))    ; VP=VP+VT?
             ((and (VA? (head x)) (ADV? (list (second x))) (VT? (cddr x))) (cons 'VP (list (VA? (head x)) (ADV? (list (second x))) (VT? (cddr x))))) ; VP=VA+ADV+VT?
             ((and (VP?  (butlast x)) (VT? (last x))) (cons 'VP (list (VP?   (butlast x)) (VT? (last x)))))    ; VP=VP+VT?
             ((and (VP?  (butlast x)) (NP? (last x))) (cons 'VP (list (VP?   (butlast x)) (NP? (last x)))))    ; VP=VP+NP?
             ((and (VP?  (butlast x 2)) (NP? (last x 2))) (cons 'VP (list (VP?   (butlast x 2)) (NP? (last x 2)))))    ; VP=VP+NP?
             (T                                    NIL                                              )))  ; デフォルト

(defun ADJ? (x)
       (cond ((not (atom? x))          NIL           )                                                   ; 単語ではない.
             ((equal (car x) 'black     ) (cons 'ADJ x) )                                                   ; ADJ=black?
             ((equal (car x) 'blue      ) (cons 'ADJ x) )                                                   ; ADJ=blue?
             ((equal (car x) 'happy     ) (cons 'ADJ x) )                                                   ; ADJ=happy?
             (T                        NIL           )))                                                 ; デフォルト

(defun ADV? (x)
       (cond ((not (atom? x))          NIL           )                                                   ; 単語ではない.
             ((equal (car x) 'already    ) (cons 'ADV x) )                                                   ; ADV=already?
             ((equal (car x) 'always     ) (cons 'ADV x) )                                                   ; ADV=always?
             ((equal (car x) 'not        ) (cons 'ADV x) )                                                   ; ADV=not?
             (T                        NIL           )))                                                 ; デフォルト

(defun ART? (x)
       (cond ((not (atom? x))          NIL           )                                                   ; 単語ではない.
             ((equal (car x) 'a      ) (cons 'ART x) )                                                   ; ART=a?
             ((equal (car x) 'an     ) (cons 'ART x) )                                                   ; ART=an?
             ((equal (car x) 'the    ) (cons 'ART x) )                                                   ; ART=the?
             (T                        NIL           )))                                                 ; デフォルト

(defun PRON? (x)
       (cond ((not (atom? x))          NIL           )                                                   ; 単語ではない.
             ((equal (car x) 'it     ) (cons 'PRON x))                                                   ; PRON=it?
             ((equal (car x) 'these  ) (cons 'PRON x))                                                   ; PRON=these?
             ((equal (car x) 'this   ) (cons 'PRON x))                                                   ; PRON=this?
             ((equal (car x) 'I      ) (cons 'PRON x))                                                   ; PRON=I?
             ((equal (car x) 'she    ) (cons 'PRON x))                                                   ; PRON=she?
             ((equal (car x) 'that   ) (cons 'PRON x))                                                   ; PRON=that?
             ((equal (car x) 'they   ) (cons 'PRON x))                                                   ; PRON=they?
             ((equal (car x) 'we     ) (cons 'PRON x))                                                   ; PRON=we?
             ((equal (car x) 'three  ) (cons 'PRON x))                                                   ; PRON=three?
             ((equal (car x) 'he     ) (cons 'PRON x))                                                   ; PRON=he?
             ((equal (car x) 'you    ) (cons 'PRON x))                                                   ; PRON=you?
             (T                        NIL           )))                                                 ; デフォルト

(defun PRONPOS? (x)
       (cond ((not (atom? x))          NIL           )                                                   ; 単語ではない.
             ((equal (car x) 'her     ) (cons 'PRONPOS x))                                                   ; PRON=her?
             ((equal (car x) 'his  ) (cons 'PRONPOS x))                                                   ; PRON=his?
             ((equal (car x) 'your   ) (cons 'PRONPOS x))                                                   ; PRON=your?
             (T                        NIL           )))                                                 ; デフォルト

(defun N? (x)
       (cond ((not (atom? x))          NIL           )                                                   ; 単語ではない.
             ((equal (car x) 'apple  ) (cons 'N x)   )                                                   ; N=apple?
             ((equal (car x) 'apples ) (cons 'N x)   )                                                   ; N=apples?
             ((equal (car x) 'book   ) (cons 'N x)   )                                                   ; N=book?
             ((equal (car x) 'Ichiro ) (cons 'N x)   )                                                   ; N=Ichiro?
             ((equal (car x) 'cards  ) (cons 'N x)   )                                                   ; N=cards?
             ((equal (car x) 'coffee ) (cons 'N x)   )                                                   ; N=coffee?
             ((equal (car x) 'dream  ) (cons 'N x)   )                                                   ; N=dream?
             ((equal (car x) 'father ) (cons 'N x)   )                                                   ; N=father?
             ((equal (car x) 'infant ) (cons 'N x)   )                                                   ; N=infant?
             ((equal (car x) 'lunch  ) (cons 'N x)   )                                                   ; N=lunch?
             ((equal (car x) 'question) (cons 'N x)   )                                                   ; N=question?
             ((equal (car x) 'stones ) (cons 'N x)   )                                                   ; N=stones?
             (T                        NIL           )))                                                 ; デフォルト

(defun VA? (x)
       (cond ((not (atom? x))          NIL           )                                                   ; 単語ではない.
             ((equal (car x) 'can    ) (cons 'VA x)  )                                                   ; VA=can?
             ((equal (car x) 'does   ) (cons 'VA x)  )                                                   ; VA=does?
             ((equal (car x) 'have   ) (cons 'VA x)  )                                                   ; VA=have?
             ((equal (car x) 'were   ) (cons 'VA x)  )                                                   ; VA=were?
             (T                        NIL           )))                                                 ; デフォルト

(defun VI? (x)
       (cond ((not (atom? x))          NIL           )                                                   ; 単語ではない.
             ((equal (car x) 'are    ) (cons 'VI x)  )                                                   ; VI=are?
             ((equal (car x) 'is     ) (cons 'VI x)  )                                                   ; VI=is?
             (T                        NIL           )))                                                 ; デフォルト

(defun VT? (x)
       (cond ((not (atom? x))          NIL           )                                                   ; 単語ではない.
             ((equal (car x) 'include) (cons 'VT x)  )                                                   ; VT=include?
             ((equal (car x) 'reads  ) (cons 'VT x)  )                                                   ; VT=reads?
             ((equal (car x) 'asked  ) (cons 'VT x)  )                                                   ; VT=asked?
             ((equal (car x) 'do     ) (cons 'VT x)  )                                                   ; VT=do?
             ((equal (car x) 'dreamed) (cons 'VT x)  )                                                   ; VT=dreamed?
             ((equal (car x) 'had    ) (cons 'VT x)  )                                                   ; VT=had?
             ((equal (car x) 'hold   ) (cons 'VT x)  )                                                   ; VT=hold?
             ((equal (car x) 'like   ) (cons 'VT x)  )                                                   ; VT=like?
             ((equal (car x) 'saw    ) (cons 'VT x)  )                                                   ; VT=saw?
             ((equal (car x) 'throwing) (cons 'VT x)  )                                                   ; VT=throwing?
             ((equal (car x) 'want   ) (cons 'VT x)  )                                                   ; VT=want?
             (T                        NIL           )))                                                 ; デフォルト

(setq sen1 (list 'these 'are 'apples)        )
(setq sen2 (list 'this 'is 'an 'apple)       )
(setq sen3 (list 'apples 'include 'an 'apple))
(setq sen4 (list 'Ichiro 'reads 'a 'book)    )
(setq sen5 (list 'it 'is 'the 'blue 'book)   )
(setq sen6 (list 'we 'want ' three)   )
(setq sen7 (list 'he 'asked 'a 'question)   )
(setq sen8 (list 'i 'saw 'your 'father)   )
(setq sen9 (list 'she 'dreamed 'a 'happy 'dream)   )
(setq sen10 (list 'you 'always 'do 'that)   )
(setq sen11 (list 'they 'were 'throwing 'stones)   )
(setq sen12 (list 'an 'infant 'can 'not 'hold 'cards)   )
(setq sen13 (list 'i 'have 'already 'had 'lunch)   )
(setq sen14 (list 'she 'does 'not 'like 'black 'coffee)   )

(defun test_parse (sen)
       (print " ")
       (print sen)
       (print (S? sen)))

;; (setq pars1 (test_parse sen1))
;; (THESE ARE APPLES)
;; (S (NP (PRON THESE)) (VP (VI ARE) (NP (N APPLES))))

;; (setq pars2 (test_parse sen2))
;; (THIS IS AN APPLE)
;; (S (NP (PRON THIS)) (VP (VI IS) (NP (ART AN) (NP (N APPLE)))))

;; (setq pars3 (test_parse sen3))
;; (APPLES INCLUDE AN APPLE)
;; (S (NP (N APPLES)) (VP (VT INCLUDE) (NP (ART AN) (NP (N APPLE)))))

;; (setq pars4 (test_parse sen4))
;; (ICHIRO READS A BOOK)
;; (S (NP (N ICHIRO)) (VP (VT READS) (NP (ART A) (N BOOK))))

;; (setq pars5 (test_parse sen5))
;; (IT IS THE BLUE BOOK)
;; (S (NP (PRON IT)) (VP (VI IS) (NP (ART THE) (ADJ BLUE) (N BOOK))))

;; (setq pars6 (test_parse sen6))
;; (WE WANT THREE)
;; (S (NP (PRON WE)) (VP (VT WANT) (NP (PRON THREE))))

;; (setq pars7 (test_parse sen7))
;; (HE ASKED A QUESTION)
;; (S (NP (PRON HE)) (VP (VT ASKED) (NP (ART A) (N QUESTION))))

;; (setq pars8 (test_parse sen8))
;; (I SAW YOUR FATHER)
;; (S (NP (PRON I)) (VP (VT SAW) (NP (PRONPOS YOUR) (N FATHER))))

;; (setq pars9 (test_parse sen9))
;; (SHE DREAMED A HAPPY DREAM)
;; (S (NP (PRON SHE)) (VP (VT DREAMED) (NP (ART A) (ADJ HAPPY) (N DREAM)))) 

;; (setq pars10 (test_parse sen10))
;; (YOU ALWAYS DO THAT)
;; (S (NP (PRON YOU)) (VP (VP (ADV ALWAYS) (VT DO)) (NP (PRON THAT))))

;; (setq pars11 (test_parse sen11))
;; (THEY WERE THROWING STONES)
;; (S (NP (PRON THEY)) (VP (VP (VA WERE) (VT THROWING)) (NP (N STONES))))

;; (setq pars12 (test_parse sen12))
;; (AN INFANT CAN NOT HOLD CARDS)
;; (S (NP (ART AN) (N INFANT)) (VP (VP (VA CAN) (ADV NOT) (VT HOLD)) (NP (N CARDS))))

;; (setq pars13 (test_parse sen13))
;; (I HAVE ALREADY HAD LUNCH)
;; (S (NP (PRON I)) (VP (VP (VA HAVE) (ADV ALREADY) (VT HAD)) (NP (N LUNCH))))

;; (setq pars14 (test_parse sen14))
;; (SHE DOES NOT LIKE BLACK COFFEE)
;; (S (NP (PRON SHE)) (VP (VP (VA DOES) (ADV NOT) (VT LIKE)) (NP (ADJ BLACK) (N COFFEE))))