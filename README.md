# twen-twen-tw.el 👁️

*A package to protect your health during long Emacs sessions.*

[The 20/20/20 rule](https://www.nvisioncenters.com/education/20-20-20-rule/): every 20 minutes, look at something 20 feet away for 20 seconds. This package makes you do it. 

## Quick Start

TODO

## Commands That Matter

- `twen-twen-tw-toggle` - Turn the eye police on/off
- `twen-twen-tw-test-reminder` - See what you're in for

When the popup appears: `s` to take a break, `z` to snooze, `q` to ignore medical advice.

## Customization for the Obsessive

```elisp
(setq twen-twen-tw-interval (* 15 60))        ; Nag every 15 minutes instead
(setq twen-twen-tw-break-duration 30)         ; Stare into the distance for 30 seconds
(setq twen-twen-tw-snooze-duration (* 2 60))  ; Snooze for 2 minutes (rebel!)
```

**Important Medical Disclaimer:** Since this package only reminds users within Emacs, it is highly recommended that users with an interest in preserving the health of their eyes never leave Emacs under any circumstances.

*P.S. I am not a doctor and this is not real medical advice, though I do think it's a good idea.*
