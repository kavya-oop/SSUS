# SSUS (Secretly Shoot Your Shot) *attempt two*

Chronicles of building a flutter webapp, for a quirky use case. 

<img width="387" height="809" alt="image" src="https://github.com/user-attachments/assets/e2a581ce-9250-445c-9864-3710ea6c0cdb" />
<img width="387" height="809" alt="image" src="https://github.com/user-attachments/assets/f3a4c1bd-06f5-406b-9f03-88f55e6b43a9" />
<img width="387" height="809" alt="image" src="https://github.com/user-attachments/assets/ca685a10-315f-4f3a-bc4d-0b02adc107b4" />
<img width="396" height="804" alt="image" src="https://github.com/user-attachments/assets/e5be0d41-d789-4a61-9fcd-4060d76ad560" />
<img width="840" height="443" alt="image" src="https://github.com/user-attachments/assets/2887a820-38ea-409a-9af2-2b2f228ae51a" />

---

## Main functionality:
Enable users to "secretly shoot their shot" with someone they like. Essentially a dating app designed to help people connect with those they’ve met in real life but didn’t have the opportunity (or courage) to express interest to directly. The app enables users to shoot their shot anonymously, then only revealing identities when there’s mutual interest. 

---

## The Problem
- Traditional dating apps feel artificial — people swipe on strangers with no real-world connection.  
- Missed connections in real life often go unresolved because people hesitate to express interest in the moment.  
- Many users want a way to *test mutual interest* without the risk of embarrassment.  

---

## The Solution
SSUS provides a low-pressure, gamified way to reconnect with people you’ve already encountered offline. Instead of cold-starting with strangers, it works by:
1. Allowing users to send anonymous interest signals (“shoot their shot”) to people they’ve seen.  
2. Gamifying the reveal process so the recipient only has three attempts to guess who sent the shot.  
3. Only revealing identities if the guess is correct or if interest is mutual.
4. Implemented a tracking system with penalties if someone tries to game the system by lying about who they like.
   
---

## Features
- **SUS Page (Shoot Your Shot)**: Users can send anonymous interest to someone they’ve met.  
- **SUS Received Page**: Users see interest signals sent to them and play a guessing game to identify who it might be.  
- **Gamified Reveal**: Correct guesses lead to identity reveals, and mutual interest unlocks chat functionality.  
- **Lightweight Profile System**: Users don’t endlessly swipe; instead, the app focuses on people they’ve already encountered.  
- **Privacy & Safety**: Identities are protected until both sides show genuine interest.

---

## User Flow
1. User logs in / signs up, set's up account.
2. On the **SUS Page**, they submit a “shot” toward someone they’ve met.  
3. That person sees the “shot” on their **SUS Received Page**.  
4. The recipient guesses who might have sent it.  
   - If correct → identity is revealed.  
   - If mutual → chat unlocks.  
   - If incorrect → remains anonymous.  

---

## How It Was Built (MVP)
- **Frontend**: Mobile-based MVP with Flutter for cross-platform access.
- **Backend**: Supabase for authentication, real-time database, and storage.  
- **Data Structure**:  
  - Users table (profile info, IDs).  
  - SUS table (tracks who sent interest, to whom, guess attempts, reveal status).  
- **Messaging Component**: Implemented using Supabase.  
- **Search / Discovery**: Simple input for Instagram/LinkedIn handles rather than complex social graph matching.
- **Emailing**: Used Resend's API connected to custom domain and Supabase edge functioons to send automated emails.

---

## Final Thoughts
While this README file contains the overview of the app, there's actually a lot more functionality actually embedded into this app, that I decided to incorporate after having friends test the app. I decided to stash the project for now, but ultimately I learned a lot and it was honestly really fun building this app!
###Learnings
- Flutter
- Setting up email services through custom domains
- Supabase (auth, database, edge functions, RLS, storage)
- iOS app development
- Android app development

