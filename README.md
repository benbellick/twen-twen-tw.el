# twen-twen-tw.el 👁️

*A package to protect your health during long Emacs sessions.*

[The 20/20/20 rule](https://www.nvisioncenters.com/education/20-20-20-rule/): every 20 minutes, look at something 20 feet away for 20 seconds. This package _makes_ you do it.

## Installation

Using `use-package`:

```elisp
(use-package twen-twen-tw
  :vc (:url "https://github.com/benbellick/twen-twen-tw.el.git")
  :config
  (twen-twen-tw-mode 1))
```

You'll know that your eyes are protected if you see `20/20/20` in the modeline. 

## Usage
With the global mode on, you will be prompted to look at something far away every 20 minutes. When the popup appears: `s` to take a break, `z` to snooze, `q` to ignore medical advice.

## Useful Commands

- `twen-twen-tw-toggle` - Toggle eye protection
- `twen-twen-tw-test-reminder` - See what the warning looks like

## Customization

```elisp
(setq twen-twen-tw-interval 15)        ; Enforce breaks every 15 minutes instead
(setq twen-twen-tw-break-duration 30)  ; Take 30 second breaks instead
(setq twen-twen-tw-snooze-duration 2)  ; Snooze for 2 minutes instead
```

**Important Medical Disclaimer:** Since this package only reminds users within Emacs, it is highly recommended that users with an interest in preserving the health of their eyes never leave Emacs under any circumstances.

*P.S. I am not a doctor and this is not real medical advice, though I do think it's a good idea.*
