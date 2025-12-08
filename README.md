# AD599-A1-Team-07-Final-Project

# Predicting Medical Appointment No-Shows

##  Project Overview
No-shows create operational inefficiencies and reduce access to care in healthcare systems.
This project aims to identify key factors affecting appointment attendance and build a machine learning model to predict no-show risk, enabling targeted interventions to reduce missed appointments.

The project includes:
- SQL-based exploratory data analysis (EDA)
- Machine learning classification modeling
- Business insights and strategic recommendations

---

## Dataset Description

The relational SQLite database contains six primary tables:

| Table | Description |
|-------|-------------|
| `patients` | Patient demographics including age, gender, city, birthdate, and registration date |
| `doctors` | Doctor information including specialty and hire date |
| `appointments` | Core visit records: patient, doctor, appointment time, visit reason, and attendance status |
| `prescriptions` | Medication records including dosage, supply duration, and refill flag |
| `invoices` | Financial activity such as billed/paid amount and payment method |
| `procedures` | Medical procedures and associated base cost |

Target variable:  
`attendance_failure` → 1 = no_show/canceled, 0 = completed

---

##  Key Insights from SQL Analysis
Initial SQL exploration found that:
- Demographics and scheduling variables (weekday, hour, city) show **little difference** in no-show patterns
- This indicates no-show behavior is **complex and difficult to segment with simple rules**
- Motivational and financial signals show **slightly stronger** patterns

 **Conclusion: SQL insights alone are insufficient — behavioral interactions require ML modeling**

---

##  Machine Learning Modeling

Models Tested:
- Logistic Regression
- K-Nearest Neighbors
- Decision Tree
- Random Forest (Best Performance)

**Best Model: Random Forest**
- AUC: ~0.60 (moderate predictive capability)
- Most important feature: `num_previous_no_shows`

> Even moderate predictive power enables clinics to intervene earlier for high-risk patients.

---

## Visuals Included
- Time-Based Visuals
- Bar charts
- Distribution plots
- Correlation matrix heatmap
- ROC curve

---

##  Business Value
Enable early identification of high-risk patients
Using behavioral history and model predictions to trigger proactive reminders and follow-up support.

Optimize resource allocation and reduce revenue loss
Scheduling staff can overbook or provide backup planning during high-risk windows to reduce idle provider time.

Improve patient engagement and care continuity
Personalized outreach toward low-commitment patients can increase attendance and support better long-term outcomes.
---

##  Team Members
Team 7 
- Haoran Guo
- Jinyi Cui
- Xiangwen Wang
- Ruoqi  Zhou
- Quan Li

Instructor: Prof. Sree Kumar Valath Bhuan Das

---

##  Tech Stack
- Python (pandas, scikit-learn, matplotlib)
- SQL (SQLiteStudio)
- GitHub for collaboration

---

##  Repository Structure
The repository contains the full workflow of our AD599 final project, structured by task:
README.md ← Project overview
TASK1 & TASK2 .pdf ← SQL EDA & schema understanding summary 
TASK2.sql ← SQL queries 
TASK3 Code part.ipynb ← Machine learning implementation 
TASK3 ML Summary.pdf ← Task 3 modeling results & evaluation report
TASK4.ipynb ← Visualization analysis
TASK4.pdf ←  Visualization deliverable 
TASK5 Final Business Recommendation.pdf ← Business value & strategic recommendations
---

> _"Better scheduling intelligence means healthier patients and more efficient clinics."_
