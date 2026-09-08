# Interactive Virtual Classroom with Screen Sharing & Real-Time Annotation Demo

A UIKit sample for building an interactive iOS classroom with the Zoom Video SDK. Teachers and students can join the same live session, share classroom content, collaborate with real-time annotations, and see participant presence as it changes.

Use of this sample app is subject to our [Terms of Use](https://explore.zoom.us/en/video-sdk-terms/).

## Start / Join View

The entry screen collects a display name and class code before joining a classroom. It includes student and teacher-oriented entry states, keyboard-safe form handling, and JWT-based Video SDK authentication.

<p align="center">
  <img src="https://github.com/user-attachments/assets/1c4e39ab-81fa-4d45-b93c-1a2676f6ba8c" width="320">
</p>

## In-Class View

After joining, the classroom displays local and remote video tiles, a compact local preview during content sharing, audio/video controls, and a live participant list.

Participants are labelled as Teacher when Zoom identifies them as a host or manager; everyone else is shown as a Student.

<p align="center">
  <img src="https://github.com/user-attachments/assets/dceaf32a-ff15-42d5-8cb6-8a9ebb995b1c" width="320">
  <img src="https://github.com/user-attachments/assets/e1f229d2-dfd4-4841-9efd-87ab0674f3c4" width="320">
</p>

## Screen Sharing and Annotation View

Users can share the app through in-app screen sharing or present one of the included algebra lesson PDFs. The floating annotation controls provide pens, highlighters, arrows, erasers, colour selection, undo, redo, and clear-all actions.

The app temporarily disables conflicting PDF and share-view gestures while annotating, then restores navigation when annotation ends.

<p align="center">
  <img src="https://github.com/user-attachments/assets/fd8cd631-a22f-4ffb-a7fa-8d5f32b47537" width="320">
  <img src="https://github.com/user-attachments/assets/eb1d13a8-9a66-405b-ba73-6bb17bffcdfb" width="320">
</p>

## Features
This repository demonstrates the basic capabilities of the Video SDK.
- Zoom Video SDK session join and leave flow
- JWT-based session authentication
- Student and teacher classroom entry UI
- Local and remote video rendering
- Audio mute/unmute controls
- Video start/stop controls
- Live participant roster with role, audio, and video status
- In-app screen sharing and PDF lesson sharing with bundled algebra handouts
- Real-time Zoom annotations with Pen, highlighter, arrow, and eraser tools. Participants can also annotation with different colour along with undo, redo, and clear-all annotation actions

## Need Help?
If you're looking for help, try Developer Support or our Developer Forums. Priority support is also available with Zoom Premier Developer Support plans.
