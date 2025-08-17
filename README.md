# twen-twen-tw.el

An Emacs package that implements the 20/20/20 rule to reduce eye strain: every 20 minutes, look at something 20 feet away for 20 seconds.

## Features

- Configurable reminder intervals (default: 20 minutes)
- Beautiful popup notifications using posframe
- 20-second countdown timer with visual feedback
- Snooze functionality (default: 5 minutes)
- Customizable break duration
- Easy start/stop/toggle commands

## Requirements

- Emacs 25.1+
- `posframe` package (for popup notifications)

## Installation

1. Install the `posframe` package (available on MELPA):
   ```elisp
   M-x package-install RET posframe RET
   ```

2. Add this package to your load path and require it:
   ```elisp
   (add-to-list 'load-path "/path/to/twen-twen-tw.el")
   (require 'twen-twen-tw)
   ```

## Usage

### Basic Commands

- `M-x twen-twen-tw-start` - Start the reminder system
- `M-x twen-twen-tw-stop` - Stop the reminder system  
- `M-x twen-twen-tw-toggle` - Toggle the system on/off
- `M-x twen-twen-tw-test-reminder` - Show a test reminder immediately

### Minor Mode

Enable the minor mode for automatic startup:

```elisp
(twen-twen-tw-mode 1)
```

### Popup Controls

When a reminder popup appears:
- Press `s` to start the 20-second break
- Press `z` to snooze for 5 minutes
- Press `q` to dismiss and schedule next reminder

## Configuration

Customize the behavior with these variables:

```elisp
;; Reminder interval (default: 20 minutes)
(setq twen-twen-tw-interval (* 30 60)) ; 30 minutes

;; Break duration (default: 20 seconds)  
(setq twen-twen-tw-break-duration 30) ; 30 seconds

;; Snooze duration (default: 5 minutes)
(setq twen-twen-tw-snooze-duration (* 10 60)) ; 10 minutes
```

Or use the customization interface:
```elisp
M-x customize-group RET twen-twen-tw RET
```

## The 20/20/20 Rule

The 20/20/20 rule is recommended by eye care professionals to reduce digital eye strain:

- Every **20 minutes**
- Look at something **20 feet away**  
- For at least **20 seconds**

This helps relax the focusing muscles in your eyes and reduce fatigue from prolonged screen use.