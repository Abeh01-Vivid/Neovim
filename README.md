Project: dwm-pulse
A lightweight, modular Linux Desktop Environment built around dwm

You are an experienced Linux desktop environment developer and C programmer. Your task is to develop dwm-pulse, an enhanced fork of suckless dwm that evolves into a complete, lightweight desktop environment while preserving dwm's performance, simplicity, and keyboard-driven philosophy.

Do not simply combine random patches. Build a cohesive desktop environment with a consistent design language, modular architecture, and well-integrated components.

1. Core philosophy
Keep the system lightweight and responsive.
Use C for core components wherever practical.
Preserve dwm's tiling window management philosophy.
Avoid unnecessary dependencies and background services.
Make everything configurable through C configuration files.
Support X11 initially.
Prefer modular components that can be enabled, disabled, or replaced.
Keep the system usable without a mouse.
Avoid unnecessary abstractions and excessive code complexity.

The result should feel like a complete desktop environment, not just dwm with extra patches.

2. Window manager improvements

Expand the existing dwm functionality:

Dynamic, floating, monocle, grid, deck, and centered-master layouts.
Adjustable gaps and smart gaps.
Per-tag layout persistence.
Named and configurable workspaces.
Independent monitor workspaces.
Window swallowing.
Window grouping and marking.
Directional window navigation.
Improved fullscreen behavior.
Better multi-monitor handling.
Advanced window rules.
Scratchpad manager with multiple named scratchpads.
Window focus history.
Configurable borders, opacity, and colors where supported.
Layout presets and restoration.

Maintain compatibility with existing dwm configuration conventions where possible.

3. Pulse status bar

Create a sophisticated modular status bar that acts as the central control panel.

The bar should support:

Three configurable sections: left, center, and right.
Icons, text, colors, and custom formatting.
Clickable modules.
Left, middle, and right mouse-button actions.
Scroll interactions.
Custom module update intervals.
Dynamic colors based on system state.
Optional tooltips and popup menus.
Multiple themes.
Font and icon configuration.
Per-monitor status bars.
Configurable padding, spacing, and separators.
Built-in status modules

Implement the following:

CPU usage and temperature.
RAM and swap usage.
GPU usage and temperature where supported.
Disk usage.
Battery percentage, charging state, and estimated remaining time.
Audio volume and mute state.
Microphone mute state.
Network connection, signal strength, and bandwidth.
Wi-Fi information.
Bluetooth state.
Date and time.
Keyboard layout.
Active VPN indicator.
Music playback information.
Notification count.
Package update count.

Each module must be independently configurable and capable of being disabled.

4. Desktop control center

Create a lightweight control center accessible from the status bar or a keyboard shortcut.

Include:

Volume controls.
Brightness controls.
Wi-Fi controls.
Bluetooth controls.
Battery information.
Display settings.
Keyboard layout settings.
Theme selection.
Notification settings.
Power management options.

The control center should have a consistent interface and should not require launching a full settings application.

5. Notification system

Implement a lightweight notification daemon.

Features:

Desktop notification popups.
Notification history.
Notification dismissal.
Configurable notification duration.
Application-specific notification rules.
Do Not Disturb mode.
Notification sounds (optional).
Notification count in the status bar.
Critical notification handling.
Keyboard shortcuts for notification management.

Prefer compatibility with the standard freedesktop.org notification specification.

6. Application launcher

Create an application launcher integrated with dwm-pulse.

Features:

Search installed applications.
Desktop entry support.
Fuzzy searching.
Keyboard navigation.
Application icons.
Recently launched applications.
Custom command execution.
Configurable keybindings.
Optional command history.

Keep the launcher fast and minimal.

7. Settings and configuration

Develop a unified configuration interface.

Allow users to configure:

Themes and colors.
Fonts and icons.
Status bar modules.
Keyboard shortcuts.
Window management behavior.
Notifications.
Audio.
Displays.
Power management.
Network preferences.
Startup applications.

Keep advanced configuration available through C headers and configuration files.

Do not make a graphical settings application mandatory.

8. Desktop appearance and themes

Create a cohesive visual design system.

Support:

Nord.
Gruvbox.
Catppuccin.
Dracula.
Monochrome.
Custom user themes.

Include:

Consistent colors across all components.
Configurable borders.
Rounded popup windows where supported.
Optional transparency.
Consistent typography.
Icon support.
Configurable spacing and padding.

Avoid making visual effects mandatory.

9. Desktop utilities

Provide a collection of lightweight utilities:

Screenshot utility.
Clipboard manager.
Wallpaper manager.
Screen brightness control.
Audio control.
File manager integration.
Lock screen integration.
Power menu.
Calendar popup.
System monitor integration.
Media controls.
Idle management.
Screen locking.
Startup application manager.

Prefer existing lightweight Linux utilities where implementing replacements would add unnecessary complexity.

10. Power management

Implement desktop power management integration:

Suspend.
Hibernate where supported.
Shutdown.
Restart.
Screen locking.
Idle detection.
Automatic screen blanking.
Battery warnings.
Low-battery actions.
Display power management.

Use established Linux interfaces and utilities rather than implementing hardware control from scratch.

11. Architecture

Organize the project into separate components.

Suggested structure:

dwm-pulse/ ├── wm/ │ ├── dwm.c │ ├── config.h │ └── layouts.c ├── pulse/ │ ├── bar.c │ ├── modules.c │ ├── events.c │ ├── colors.c │ └── popups.c ├── daemon/ │ ├── pulse-daemon.c │ └── ipc.c ├── modules/ │ ├── cpu.c │ ├── memory.c │ ├── audio.c │ ├── network.c │ ├── battery.c │ ├── bluetooth.c │ └── clock.c ├── launcher/ ├── notifications/ ├── settings/ ├── utilities/ ├── themes/ ├── config/ ├── scripts/ ├── docs/ └── Makefile

This structure is a starting point. Adjust it as necessary to create a clean and maintainable codebase.

12. Technical requirements
Primarily C.
X11 support initially.
Use Xlib and existing lightweight Linux libraries where appropriate.
Follow freedesktop.org specifications where relevant.
Use IPC between independent components.
Avoid blocking the window manager during system information collection.
Use efficient update intervals.
Handle missing hardware and unavailable services gracefully.
Avoid unnecessary polling.
Provide proper cleanup and signal handling.
Include useful error messages.
Make compilation reproducible.
Document dependencies and installation instructions.

Do not introduce unnecessary dependencies just to implement features that can be handled through existing system interfaces.

13. Development roadmap

Develop the project incrementally.

Phase 1 — Foundation
Fork and clean up dwm.
Establish project architecture.
Implement improved layouts.
Add gaps and workspace improvements.
Establish theme infrastructure.
Phase 2 — Pulse bar
Implement the modular status bar.
Add CPU, RAM, battery, volume, network, and clock modules.
Add clickable regions.
Implement module configuration.
Phase 3 — Desktop integration
Implement application launcher.
Add notification daemon.
Add control center.
Add popup infrastructure.
Phase 4 — Desktop utilities
Integrate wallpaper management.
Add screenshot and clipboard utilities.
Add power management.
Add media controls.
Add lock screen integration.
Phase 5 — Polish
Improve themes.
Improve multi-monitor support.
Add configuration documentation.
Optimize performance.
Test component failure and recovery.
Create installation scripts.
14. Important development instructions
First inspect the existing repository and understand its architecture.
Identify the current dwm version and existing modifications.
Do not overwrite working features without understanding them.
Develop one component at a time.
Compile and test after every major implementation.
Do not leave placeholder functions pretending to implement functionality.
Do not claim a feature works until it has been implemented and tested.
Keep the project usable throughout development.
Document every new dependency.
Prioritize stability over feature quantity.

When encountering a feature that is too large to implement immediately, establish its interface and document its implementation plan instead of creating fake functionality.

Final objective

Transform dwm-pulse into a cohesive, lightweight Linux desktop environment.

It should combine:

The speed and flexibility of dwm.
The convenience of a traditional desktop environment.
The modularity of a Unix system.
The visual consistency of a modern desktop.
The configurability of the suckless ecosystem.

The final product should feel like its own desktop environment, with a recognizable identity, rather than a collection of unrelated Linux utilities.

Build something that is lightweight, beautiful, functional, and genuinely enjoyable to use.
# Neovim
