# Interactive Virtual Classroom with Screen Sharing & Real-Time Annotation Demo

A UIKit sample for building an interactive iOS classroom with the Zoom Video SDK. Teachers and students can join the same live session, share classroom content, collaborate with real-time annotations, and see participant presence as it changes.

Use of this sample app is subject to our [Terms of Use](https://explore.zoom.us/en/video-sdk-terms/).

## Start / Join View

The entry screen collects a display name and class code before joining a classroom. It includes student and teacher-oriented entry states, keyboard-safe form handling, and JWT-based Video SDK authentication.

<table align="center">
  <thead>
    <tr>
      <th align="center">iPhone</th>
      <th align="center">iPad</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center">
        <img
          src="https://github.com/user-attachments/assets/1c4e39ab-81fa-4d45-b93c-1a2676f6ba8c"
          alt="Interactive Virtual Classroom landing view (iPhone)"
          width="280"
        />
      </td>
      <td align="center">
        <img
          src="https://github.com/user-attachments/assets/2dff3a58-9f48-4f01-8891-f137e1d5dd82"
          alt="Interactive Virtual Classroom landing view (iPad)"
          width="480"
        />
      </td>
    </tr>
  </tbody>
</table>

## In-Class View

After joining, the classroom displays local and remote video tiles, a compact local preview during content sharing, audio/video controls, and a live participant list.

<table align="center">
  <thead>
    <tr>
      <th align="center">iPhone</th>
      <th align="center">iPad</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center">
        <img
          src="https://github.com/user-attachments/assets/dceaf32a-ff15-42d5-8cb6-8a9ebb995b1c"
          alt="Interactive Virtual Classroom In-class view (iPhone)"
          width="280"
        />
      </td>
      <td align="center">
        <img
          src="https://github.com/user-attachments/assets/39fdb1e4-95cf-49af-b91c-537821d638a9"
          alt="Interactive Virtual Classroom In-class view (iPad)"
          width="480"
        />
      </td>
    </tr>
  </tbody>
</table>

Participants are labelled as Teacher when Zoom identifies them as a host or manager; everyone else is shown as a Student.

<table align="center">
  <thead>
    <tr>
      <th align="center">iPhone</th>
      <th align="center">iPad</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center">
        <img
          src="https://github.com/user-attachments/assets/e1f229d2-dfd4-4841-9efd-87ab0674f3c4"
          alt="Interactive Virtual Classroom participants view (iPhone)"
          width="280"
        />
      </td>
      <td align="center">
        <img
          src="https://github.com/user-attachments/assets/79aa5318-a722-47e0-8b3c-2431fee95f4c"
          alt="Interactive Virtual Classroom participants view (iPad)"
          width="480"
        />
      </td>
    </tr>
  </tbody>
</table>

## Screen Sharing and Annotation View

Users can share the app through in-app screen sharing or present one of the included algebra lesson PDFs. The floating annotation controls provide pens, highlighters, arrows, erasers, colour selection, undo, redo, and clear-all actions.

The app temporarily disables conflicting PDF and share-view gestures while annotating, then restores navigation when annotation ends.


<table align="center">
  <thead>
    <tr>
      <th align="center">iPhone</th>
      <th align="center">iPad</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center">
        <img
          src="https://github.com/user-attachments/assets/eb1d13a8-9a66-405b-ba73-6bb17bffcdfb"
          alt="Interactive Virtual Classroom annotation view (iPhone)"
          width="280"
        />
      </td>
      <td align="center">
        <img
          src="https://github.com/user-attachments/assets/4881f8e5-44ce-4182-8304-dc80e8e2b03a"
          alt="Interactive Virtual Classroom annotation view (iPad)"
          width="480"
        />
      </td>
    </tr>
  </tbody>
</table>

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
