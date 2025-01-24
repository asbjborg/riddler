# Product Requirements Document

## Overview

Riddler is a World of Warcraft addon that enables players to host and participate in trivia quizzes within the game. It provides an engaging way for guild members, raid teams, or random groups to test their knowledge and have fun during downtime.

For technical implementation details, see [[/docs/technical/architecture|Architecture Overview]].

## Core Features

### Quiz Management

- Create and edit quizzes through an in-game interface [[/docs/technical/modules/ui|UI Module]]
- Import quizzes from JSON files [[/docs/technical/data_formats|Data Formats]]
- Share quizzes with other players [[/docs/technical/modules/sharing|Sharing Module]]
- Default quiz templates included

### Quiz Gameplay

- Multiple choice and free-form questions [[/docs/technical/examples|Quiz Flow Examples]]
- Timed questions with configurable duration [[/docs/technical/commands|Time Management]]
- Point system with streaks and difficulty bonuses
- Dynamic player discovery (no explicit join required)
- Welcoming messages for new participants

### Scoring System

- Base points for correct answers
- Bonus points for answer streaks
- Difficulty multipliers
- Periodic score updates
- Detailed end-of-quiz summary

For implementation details, see [[/docs/technical/modules/quiz_engine|Quiz Engine]].

### User Interface

- Clean, intuitive design
- Easy-to-read question display
- Real-time scoreboard
- Quiz editor with preview [[/docs/technical/implementation_details#question-editor-ui|Editor UI]]
- Statistics and history tracking

## User Experience

### Host Experience

1. Select or create a quiz
2. Start quiz in desired chat channel
3. Monitor progress and scores
4. Control quiz flow (pause/resume/skip) [[/docs/technical/commands#host-commands|Host Commands]]
5. End quiz and share results

### Player Experience

1. See quiz announcement in chat
2. Read questions and submit answers
3. View score updates and progress
4. Receive end-of-quiz summary
5. Save or share received quizzes

For detailed examples, see [[/docs/technical/examples|Quiz Flow Examples]].

## Constraints

### Technical Limitations

- WoW addon restrictions [[/docs/technical/api|WoW API Usage]]
- Chat channel limitations
- File size constraints
- Memory usage limits [[/docs/technical/implementation_details#performance-monitoring|Performance Monitoring]]

### Out of Scope

- Cross-realm functionality
- Voice integration
- Advanced language support
- Bulk import/export
- External API integration

## Success Metrics

- Active quiz sessions per day
- Number of players per quiz
- Quiz completion rate
- Player retention rate
- Quiz sharing frequency

For performance monitoring details, see [[/docs/technical/implementation_details#performance-monitoring|Performance Metrics]].

## Future Considerations

- Additional question types
- Achievement system
- Tournament mode
- Team-based quizzes
- Custom scoring rules

## Technical Documentation

- [[/docs/technical/architecture|Architecture Overview]]
- [[/docs/technical/api|WoW API Usage]]
- [[/docs/technical/data_formats|Data Formats]]
- [[/docs/technical/commands|Commands and Controls]]
- [[/docs/technical/examples|Quiz Flow Examples]]
- [[/docs/technical/implementation_details|Implementation Details]]

### Module Documentation

- [[/docs/technical/modules/quiz_engine|Quiz Engine]]
- [[/docs/technical/modules/ui|User Interface]]
- [[/docs/technical/modules/storage|Storage]]
- [[/docs/technical/modules/sharing|Sharing]]
