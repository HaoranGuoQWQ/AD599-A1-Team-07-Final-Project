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

## 🗂 Dataset Description
The relational SQLite database contains four primary tables:

| Table | Description |
|-------|-------------|
| `patients` | Demographics such as age, gender, city |
| `appointments` | Visit details including datetime, doctor, and status |
| `doctors` | Specialty and ID mapping |
| `invoices` | Payment and financial engagement information |

Target variable:  
`attendance_failure` → 1 = no_show/canceled, 0 = completed

---

## 🔍 Key Insights from SQL Analysis
Initial SQL exploration found that:
- Demographics and scheduling variables (weekday, hour, city) show **little difference** in no-show patterns
- This indicates no-show behavior is **complex and difficult to segment with simple rules**
- Motivational and financial signals show **slightly stronger** patterns

➡ **Conclusion: SQL insights alone are insufficient — behavioral interactions require ML modeling**

---

## 🤖 Machine Learning Modeling

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

## 🧩 Business Value
Enable early identification of high-risk patients
Using behavioral history and model predictions to trigger proactive reminders and follow-up support.

Optimize resource allocation and reduce revenue loss
Scheduling staff can overbook or provide backup planning during high-risk windows to reduce idle provider time.

Improve patient engagement and care continuity
Personalized outreach toward low-commitment patients can increase attendance and support better long-term outcomes.
---

## 👥 Team Members
Team 4 – Boston University  
MS Applied Business Analytics  
- Haoran Guo
- Jinyi Cui
- Xiangwen Wang
- Ruoqi  Zhou
- Quan Li

Instructor: Prof. Sree Kumar Valath Bhuan Das

---

## 🛠 Tech Stack
- Python (pandas, scikit-learn, matplotlib)
- SQL (SQLiteStudio)
- GitHub for collaboration

---

## 📦 Repository Structure

---

> _"Better scheduling intelligence means healthier patients and more efficient clinics."_
