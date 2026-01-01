# 🛒 E-commerce Funnel Analysis & Experimentation

## Excutive Summary
This project analyzes a B2C e-commerce conversion funnel to identify where users drop off and to design data-driven experiments that improve purchase conversion. Using event-level clickstream data, the analysis reveals significant checkout abandonment after users add items to cart. A simulated A/B experiment demonstrates that reducing checkout friction through trust signals could increase purchase conversion by approximately 12%, supporting a recommendation to ship the change with appropriate guardrail monitoring.

## Business Problem
Despite healthy traffic and product engagement, a large proportion of users fail to complete purchases. The business objective is to identify funnel bottlenecks and test product changes that increase conversion while minimizing risk.

## Funnel Definition & KPIs
### Funnel Stages
The conversion funnel is defined as
Page View - Product View - Add to Cart - Purchase

## Key Metrics & KPIs
* Purchase Conversion Rate (primary KPI)
* Step-to-step conversion rates
* Funnel drop-off rates
The primary KPI for experimentation is purchase conversion among users who add items to cart, as this represents the largest revenue opportunity.


## Data Overview

The analysis uses event-level clickstream data with the following structure:
* UserID – unique user identifier
* SessionID – browsing session identifier
* Timestamp – event timestamp
* EventType – user action (page_view, product_view, add_to_cart, purchase)
* ProductID – product interacted with (where applicable)
* Amount – purchase value (purchase events only)

## Key Insights
* Approximately 75% of users drop off between the Add to Cart and Purchase,this maked the checkout the primary funnel bottleneck.
* Users demonstrate added items to cart, but many fail to complete purchase.
* High-activity users convert more efficiently than low-activity users, even though they had a  lower overall volume.
* By improving checkout experience this is likely to have a great impact than increasing top-of-funnel traffic.

## Segmented Analysis
Segmenting users by activity level shows that:
* High-activity users convert at a higher rate indicating readiness to purchase with minimal friction.
* Low-activity users contribute more traffic but are less efficient to convertion, suggesting the need for improved early engagement and reassurance during checkout.

## Experiment Design
Hypothesis
To adddress the bottleneck, by adding trust signals example is secure payment and free returns messaging. More users who add to chart will complete the purchase, inceasing purchase conversation rate.

Experiment Setup
* Population: Users that added to itmes to cart atleast once
* Control: Exisitng checkout process
* Treatment: New checkout with added trust messaing
* Primary KPI: Purchase conversion rate
* Guardrails: AOV, checkout completions time, error rate


## Experiemnt Design & Rsults
A A/B tests simulated experiment to test whether adding  trust signals  during checkout reduces abandonment. 
Treated group showed an a**pproximate 11.7% lift** in purchase conversion relative to control. Due to the magnitude of the lift and low risk nature of the change. It is recommandeded to **ship the update** while monitoring guardrial metrics

## Risks & Limitations
Results are based on simulated outcomes and assume consistent user behavior. Real-world experiments may be affected by imperfect randomization, behavioral variability, and unintended UX side effects. Post-launch monitoring of order value, checkout duration, and error rates is recommended.

```
product-funnel-experiment-analysis/
│
├── data/
│   ├── raw/ecommerce_clickstream_transactions.csv
│   └── cleaned/ecommerce_clickstream_cleaned.csv
│
├── notebooks/
│   └── funnel_analysis _&_experiment_simulation.ipynb
│
├── sql/
│   └── funnel_metrics.sql
│
└── README.md

```
## Skills Demonstrated
* Product & business problem framing
* Funnel analysis and drop-off diagnosis
* KPI definition and segmentation
* Experiment design and evaluation
* Executive-level storytelling
* Python, SQL, and analytical reasoning

## Final Note
This project demonstrates how product analytics can move beyond reporting to directly inform experimentation and decision-making that drives measurable business impact.

