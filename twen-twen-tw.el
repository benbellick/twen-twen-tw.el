;;; twen-twen-tw.el --- 20/20/20 rule reminder -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author: Your Name
;; Version: 1.0.0
;; Package-Requires: ((emacs "25.1") (posframe "1.0"))
;; Keywords: health, ergonomics, reminder
;; URL: 

;;; Commentary:

;; This package implements the 20/20/20 rule reminder: every 20 minutes,
;; look at something 20 feet away for 20 seconds to reduce eye strain.
;; It displays a popup notification and provides a countdown timer.

;;; Code:

(require 'posframe)

(defgroup twen-twen-tw nil
  "20/20/20 rule reminder settings."
  :group 'health
  :prefix "twen-twen-tw-")

(defcustom twen-twen-tw-interval (* 20 60)
  "Interval in seconds between reminders (default: 20 minutes)."
  :type 'integer
  :group 'twen-twen-tw)

(defcustom twen-twen-tw-break-duration 20
  "Duration of the break in seconds (default: 20 seconds)."
  :type 'integer
  :group 'twen-twen-tw)

(defcustom twen-twen-tw-snooze-duration (* 5 60)
  "Snooze duration in seconds (default: 5 minutes)."
  :type 'integer
  :group 'twen-twen-tw)

(defvar twen-twen-tw--timer nil
  "Timer object for the main reminder.")

(defvar twen-twen-tw--countdown-timer nil
  "Timer object for the countdown.")

(defvar twen-twen-tw--active nil
  "Whether the reminder system is active.")

(defvar twen-twen-tw--break-active nil
  "Whether a break is currently active.")

(defvar twen-twen-tw--countdown-seconds 0
  "Current countdown seconds remaining.")

(defconst twen-twen-tw--popup-buffer "*twen-twen-tw-popup*")

(defface twen-twen-tw-popup-face
  '((t :inherit default
       :background unspecified
       :height 1.2))
  "Face for the 20/20/20 popup."
  :group 'twen-twen-tw)

(defface twen-twen-tw-title-face
  '((t :inherit twen-twen-tw-popup-face
       :weight bold
       :height 1.5
       :foreground "blue"
       :background unspecified))
  "Face for the popup title."
  :group 'twen-twen-tw)

(defface twen-twen-tw-countdown-face
  '((t :inherit twen-twen-tw-popup-face
       :weight bold
       :height 2.0
       :foreground "green"
       :background unspecified))
  "Face for the countdown display."
  :group 'twen-twen-tw)

(defun twen-twen-tw--create-popup-content (message &optional countdown no-keys)
  "Create popup content with MESSAGE and optional COUNTDOWN. If NO-KEYS is non-nil, don't show key instructions."
  (with-temp-buffer
    (insert "👁️ 20/20/20 Rule Reminder\n\n")
    (insert message)
    (when (numberp countdown)
      (insert "\n\n")
      (insert (format "Time remaining: %02d seconds" countdown)))
    (unless (or (numberp countdown) no-keys)
      (insert "\n\n")
      (insert "Press 's' to start break, 'z' to snooze, 'q' to dismiss"))
    (buffer-string)))

(defun twen-twen-tw--show-popup (content)
  "Show popup with CONTENT using posframe."
  (when (get-buffer twen-twen-tw--popup-buffer)
    (kill-buffer twen-twen-tw--popup-buffer))
  
  (with-current-buffer (get-buffer-create twen-twen-tw--popup-buffer)
    (erase-buffer)
    (insert content)
    (goto-char (point-min)))
  
  (posframe-show twen-twen-tw--popup-buffer
                 :string content
                 :position (cons (/ (frame-width) 2) (/ (frame-height) 3))
                 :poshandler #'posframe-poshandler-frame-center
                 :background-color (face-background 'mode-line nil t)
                 :foreground-color (face-foreground 'mode-line nil t)
                 :border-width 2
                 :border-color (face-foreground 'mode-line nil t)
                 :internal-border-width 10
                 :min-width 50
                 :min-height 10))

(defun twen-twen-tw--hide-popup ()
  "Hide the popup."
  (posframe-hide twen-twen-tw--popup-buffer)
  (when (get-buffer twen-twen-tw--popup-buffer)
    (kill-buffer twen-twen-tw--popup-buffer)))

(defun twen-twen-tw--start-countdown ()
  "Start the 20-second countdown break."
  (setq twen-twen-tw--break-active t)
  (setq twen-twen-tw--countdown-seconds twen-twen-tw-break-duration)
  
  (twen-twen-tw--show-popup 
   (twen-twen-tw--create-popup-content 
    "Look at something 20 feet away!\n\nRelax your eyes and focus on a distant object."
    twen-twen-tw--countdown-seconds))
  
  (setq twen-twen-tw--countdown-timer
        (run-at-time 1 1 'twen-twen-tw--countdown-tick)))

(defun twen-twen-tw--countdown-tick ()
  "Handle countdown timer tick."
  (setq twen-twen-tw--countdown-seconds (1- twen-twen-tw--countdown-seconds))
  
  (if (<= twen-twen-tw--countdown-seconds 0)
      (twen-twen-tw--finish-break)
    (twen-twen-tw--show-popup
     (twen-twen-tw--create-popup-content
      "Look at something 20 feet away!\n\nRelax your eyes and focus on a distant object."
      twen-twen-tw--countdown-seconds))))

(defun twen-twen-tw--finish-break ()
  "Finish the break and show completion message."
  (when twen-twen-tw--countdown-timer
    (cancel-timer twen-twen-tw--countdown-timer)
    (setq twen-twen-tw--countdown-timer nil))
  
  (setq twen-twen-tw--break-active nil)
  
  (twen-twen-tw--show-popup
   (twen-twen-tw--create-popup-content
    "Break complete! 🎉\n\nYour eyes should feel more refreshed.\nNext reminder in 20 minutes." nil t))
  
  (run-at-time 3 nil 'twen-twen-tw--hide-popup)
  (twen-twen-tw--schedule-next-reminder))

(defun twen-twen-tw--show-reminder ()
  "Show the main reminder popup."
  (unless twen-twen-tw--break-active
    (twen-twen-tw--show-popup
     (twen-twen-tw--create-popup-content
      "Time for a 20/20/20 break!\n\nLook at something 20 feet away for 20 seconds to reduce eye strain."))))

(defun twen-twen-tw--schedule-next-reminder ()
  "Schedule the next reminder."
  (when twen-twen-tw--timer
    (cancel-timer twen-twen-tw--timer))
  (setq twen-twen-tw--timer
        (run-at-time twen-twen-tw-interval nil 'twen-twen-tw--show-reminder)))

(defun twen-twen-tw--snooze ()
  "Snooze the reminder."
  (twen-twen-tw--hide-popup)
  (when twen-twen-tw--timer
    (cancel-timer twen-twen-tw--timer))
  (setq twen-twen-tw--timer
        (run-at-time twen-twen-tw-snooze-duration nil 'twen-twen-tw--show-reminder))
  (message "20/20/20 reminder snoozed for %d minutes" (/ twen-twen-tw-snooze-duration 60)))

(defun twen-twen-tw--handle-popup-key (key)
  "Handle key press KEY in popup."
  (cond
   ((eq key ?s) ; Start break
    (twen-twen-tw--start-countdown))
   ((eq key ?z) ; Snooze
    (twen-twen-tw--snooze))
   ((eq key ?q) ; Quit/dismiss
    (twen-twen-tw--hide-popup)
    (twen-twen-tw--schedule-next-reminder))))

(defun twen-twen-tw--popup-event-handler ()
  "Handle events when popup is shown."
  (let (key)
    (while (not (memq (setq key (read-key "Press 's' to start break, 'z' to snooze, 'q' to dismiss: ")) '(?s ?z ?q)))
      (message "Invalid key. Press 's' to start break, 'z' to snooze, 'q' to dismiss."))
    (twen-twen-tw--handle-popup-key key)))

(defun twen-twen-tw--cleanup-timers ()
  "Clean up all timers."
  (when twen-twen-tw--timer
    (cancel-timer twen-twen-tw--timer)
    (setq twen-twen-tw--timer nil))
  (when twen-twen-tw--countdown-timer
    (cancel-timer twen-twen-tw--countdown-timer)
    (setq twen-twen-tw--countdown-timer nil)))

;;;###autoload
(defun twen-twen-tw-start ()
  "Start the 20/20/20 reminder system."
  (interactive)
  (when twen-twen-tw--active
    (twen-twen-tw-stop))
  
  (setq twen-twen-tw--active t)
  (twen-twen-tw--schedule-next-reminder)
  (message "20/20/20 reminder started! Next reminder in %d minutes." (/ twen-twen-tw-interval 60)))

;;;###autoload
(defun twen-twen-tw-stop ()
  "Stop the 20/20/20 reminder system."
  (interactive)
  (setq twen-twen-tw--active nil)
  (setq twen-twen-tw--break-active nil)
  (twen-twen-tw--cleanup-timers)
  (twen-twen-tw--hide-popup)
  (message "20/20/20 reminder stopped."))

;;;###autoload
(defun twen-twen-tw-toggle ()
  "Toggle the 20/20/20 reminder system."
  (interactive)
  (if twen-twen-tw--active
      (twen-twen-tw-stop)
    (twen-twen-tw-start)))

;;;###autoload
(defun twen-twen-tw-test-reminder ()
  "Show a test reminder immediately."
  (interactive)
  (twen-twen-tw--show-reminder)
  (run-at-time 0.1 nil 'twen-twen-tw--popup-event-handler))

;;;###autoload
(define-minor-mode twen-twen-tw-mode
  "Minor mode for 20/20/20 rule reminders."
  :lighter " 20/20/20"
  :global t
  (if twen-twen-tw-mode
      (twen-twen-tw-start)
    (twen-twen-tw-stop)))

;; Cleanup on Emacs exit
(add-hook 'kill-emacs-hook 'twen-twen-tw--cleanup-timers)

(provide 'twen-twen-tw)
;;; twen-twen-tw.el ends here
