# Weekly Business Review — Supply Chain Analytics
## Documentation & Power BI Implementation Plan

Source file: `SupplyChain_Cleaned.csv` · 10,000 rows · 24 columns · Jan 1, 2024 – Dec 31, 2025

---

## A. Data Understanding

| Item | Detail |
|---|---|
| Rows / Columns | 10,000 transactions / 24 columns |
| Grain | One row = one order line (Order_ID is unique, no duplicates) |
| Date columns | Order_Date, Shipment_Date, Delivery_Date |
| Numeric measures | Order_Quantity, Unit_Price, Total_Cost, Shipping_Cost, Delivery_Time_Days, Inventory_Level, Profit |
| Identifiers | Order_ID, Customer_ID, Product_ID, Supplier_ID, Warehouse_ID |
| Categorical | Customer_Region (5), Customer_Country (27), Product_Category (5), Supplier_Name (10), Supplier_Region (5), Warehouse_Location (10), Transportation_Mode (4: Air/Rail/Road/Sea), Order_Status (4: Delivered/Inransit/Delayed/Cancelled) |
| Missing values | None in any column |
| Duplicate Order_IDs | None |
| Negative quantities/costs | None |
| Zero Unit_Price | 7 rows (Total_Cost still populated — flag for source review, not removed) |

**Which date field to use for weekly reporting?**
**Order_Date** is used as the primary field for the WBR calendar because it is the earliest point in the order lifecycle, is populated for 100% of rows, and represents when demand/business activity actually occurred (the trigger event). Shipment_Date and Delivery_Date are downstream and used only within delivery-performance calculations. Week = Monday-start (ISO-style), e.g. "Dec 22" = Dec 22–28, 2025.

**Latest available week:** The file's most recent week (Dec 29–31, 2025) is a **partial week** (only 3 days, 36 rows vs. ~90–110 for full weeks) and is excluded from KPI reporting. The reporting week used throughout is the latest **complete** week: **Dec 22–28, 2025**, compared against **Dec 15–21, 2025**.

---

## B. KPI Dictionary

| KPI | Definition | Formula | Business Meaning | Required Columns |
|---|---|---|---|---|
| Total Orders | Count of orders placed in the week | `COUNT(Order_ID)` filtered to week | Demand volume | Order_ID, Order_Date |
| Revenue (Order Value) | Sum of transaction value | `SUM(Total_Cost)` filtered to week | Top-line activity | Total_Cost, Order_Date |
| Profit | Sum of the provided Profit field | `SUM(Profit)` filtered to week | Bottom-line contribution (see caveat below) | Profit, Order_Date |
| Profit Margin % | Profit relative to order value | `SUM(Profit) / SUM(Total_Cost) * 100` | Directional profitability signal — **not a standard cost-margin ratio** because Profit sometimes exceeds Total_Cost in this dataset | Profit, Total_Cost |
| On-Time Delivery % | Share of resolved orders delivered without delay | `Delivered / (Delivered + Delayed) * 100` | Logistics/service reliability | Order_Status, Order_Date |
| Est. Inventory Value | Approximate stock value at time of order | `AVERAGE(Inventory_Level * Unit_Price)` for week | Rough inventory exposure (not a ledger balance) | Inventory_Level, Unit_Price |
| Low-Stock Order Rate (Stockout proxy) | % of orders placed while stock was critically low | `COUNT(Inventory_Level < 300) / COUNT(orders) * 100` | Closest valid stand-in for a stockout rate; no true stockout field exists | Inventory_Level |
| Supplier Performance % | On-time rate per supplier | `Delivered / (Delivered + Delayed) * 100`, grouped by Supplier_Name | Identifies underperforming vendors | Supplier_Name, Order_Status |
| Procurement Value by Supplier | Order value attributable to each supplier | `SUM(Total_Cost)` grouped by Supplier_Name | Spend concentration / negotiating leverage | Supplier_Name, Total_Cost |

**KPIs intentionally NOT created, with reasoning:**
- **Standalone "Procurement Cost" KPI card** — the dataset has only one monetary field per transaction (`Total_Cost`); there is no separate purchase price distinct from order value, so a second top-line card would just duplicate Revenue. Procurement cost is instead analyzed as a *dimension* (by supplier, by category), which is the analytically honest use of this field.
- **True Stockout Rate** — no stockout flag, reorder point, or safety-stock field exists. The Low-Stock Order Rate above is the closest valid alternative and is labeled as a proxy throughout.
- **Perpetual/period-end Inventory Value** — Inventory_Level is captured per transaction (9,365 near-unique Product_IDs across 10,000 rows), not as a running per-SKU ledger, so a certified "ending inventory value" cannot be computed. The Estimated Inventory Value KPI is explicitly an approximation.

---

## C. Power BI Page Structure

```
Page 1: WBR Overview
 ┌────────────────────────────────────────────────────────┐
 │ Header: "WEEKLY BUSINESS REVIEW" | Reporting week card  │
 ├────────────────────────────────────────────────────────┤
 │ Row 1: 6 KPI cards (Orders | Revenue | Profit |         │
 │        On-Time % | Est. Inventory Value | Low-Stock %)  │
 ├────────────────────────────────────────────────────────┤
 │ Row 2: Revenue Trend (line)   |  Orders Trend (bar)     │
 ├────────────────────────────────────────────────────────┤
 │ Row 3: Procurement by Supplier (stacked bar) |          │
 │        On-Time Delivery Trend (line)                    │
 ├────────────────────────────────────────────────────────┤
 │ Row 4: Supplier Performance (table) |                   │
 │        Inventory Risk (table)                           │
 ├────────────────────────────────────────────────────────┤
 │ Bottom: Operational Issues (cards/table) +               │
 │         Management Actions (table)                      │
 └────────────────────────────────────────────────────────┘

Page 2: Supplier & Procurement Detail
 - Top/Bottom 5 suppliers, procurement cost by category, cost per unit

Page 3: Inventory Detail
 - Low-stock table, inventory by category/warehouse

Slicers panel (left, on every page): Week, Customer_Region, Product_Category,
Supplier_Name, Order_Status, Transportation_Mode
```

---

## D. Visual Specification

| # | Visual Type | Title | X-axis | Y-axis | Legend | Filters | Purpose |
|---|---|---|---|---|---|---|---|
| 1 | Line chart | Weekly Revenue Trend | Week (Order_Date) | SUM(Total_Cost) | — | last 12–16 weeks | Growth/decline/volatility |
| 2 | Column chart | Weekly Orders Trend | Week | COUNT(Order_ID) | — | last 12–16 weeks | Demand pattern |
| 3 | Stacked column | Procurement Value by Supplier | Week | SUM(Total_Cost) | Supplier_Name (top 4 + Other) | last 8–12 weeks | Spend concentration |
| 4 | Line chart | On-Time Delivery % Trend | Week | On-Time % measure | — | last 12–16 weeks | Logistics performance |
| 5 | Table | Supplier Performance | — | — | — | none (all-time) | Rank suppliers, flag risk |
| 6 | Table | Inventory Risk | — | — | — | current week, Inventory_Level < 300 | Replenishment triggers |
| 7 | Bar chart | Revenue by Product Category | Category | SUM(Total_Cost) | — | all-time | Category concentration |
| 8 | Table | Delivery Reliability by Transport Mode | — | — | — | all-time | Mode-level lead time / reliability |
| 9 | Table/Cards | Operational Issues | — | — | — | current week | Exceptions this week |
| 10 | Table | Management Actions | — | — | — | current week | Recommended actions |

---

## E. DAX Measures

```dax
-- Base measures
Total Orders = COUNTROWS(SupplyChain)

Revenue = SUM(SupplyChain[Total_Cost])

Total Profit = SUM(SupplyChain[Profit])

Profit Margin % = DIVIDE([Total Profit], [Revenue], 0)

Delivered Orders = CALCULATE([Total Orders], SupplyChain[Order_Status] = "Delivered")

Delayed Orders = CALCULATE([Total Orders], SupplyChain[Order_Status] = "Delayed")

Resolved Orders = [Delivered Orders] + [Delayed Orders]

On-Time Delivery % = DIVIDE([Delivered Orders], [Resolved Orders], 0)

Cancelled Orders = CALCULATE([Total Orders], SupplyChain[Order_Status] = "Cancelled")

Cancellation Rate % = DIVIDE([Cancelled Orders], [Total Orders], 0)

Avg Delivery Days = AVERAGE(SupplyChain[Delivery_Time_Days])

Avg Inventory Level = AVERAGE(SupplyChain[Inventory_Level])

Est. Inventory Value = AVERAGEX(SupplyChain, SupplyChain[Inventory_Level] * SupplyChain[Unit_Price])

Low Stock Orders = CALCULATE([Total Orders], SupplyChain[Inventory_Level] < 300)

Low Stock Order Rate % = DIVIDE([Low Stock Orders], [Total Orders], 0)

Procurement Value = [Revenue]   -- same field, viewed by Supplier dimension

-- Week-over-Week pattern (reusable for any base measure X)
Prior Week Value =
CALCULATE(
    [Revenue],                       -- swap in any base measure
    DATEADD(SupplyChain[Week_Start], -7, DAY)
)

WoW % Change =
DIVIDE([Revenue] - [Prior Week Value], [Prior Week Value], 0)
```

**Calculated column required (if not already in the model):**
```dax
Week_Start = SupplyChain[Order_Date] - WEEKDAY(SupplyChain[Order_Date], 2) + 1
```
This produces a Monday-start week key; build a small Date/Week dimension table off it and mark it as a Date Table for correct DATEADD/time-intelligence behavior.

---

## F. Business Insights (from the current reporting week)

- **Volume up:** Orders rose from 88 to 110 (+25.0% WoW); revenue rose from ~$306K to ~$407K (+32.9% WoW).
- **Delivery improved:** On-time delivery rose from 91.0% to 97.1% (+6.1 pts), and delayed-order count fell from 7 to 3.
- **Supplier spread is tight:** all 10 suppliers sit within a ~2-point on-time band (92.2%–94.1%), so no single supplier is catastrophically underperforming, but **Crescentogistics** is the persistent bottom performer (92.24% on-time, all-time).
- **Category concentration:** Electronics (~$23.0M) and Furniture (~$13.2M) account for the large majority of all-time order value versus FMCG (~$2.7M) — procurement risk is concentrated in a small number of categories.
- **Sea freight is the slowest mode** (≈17.9 days average) vs. Air (≈3.8 days); mode choice is a lever for balancing cost against delivery-time risk.
- **Inventory risk is limited but present:** ~7% of this week's orders were placed against stock under 300 units, concentrated in Furniture, FMCG and Healthcare items.

## G. Management Actions

| Issue | Evidence | Business Impact | Priority | Recommended Action |
|---|---|---|---|---|
| Weakest supplier on-time rate | Crescentogistics: 92.2% on-time, 66 delayed orders (all-time) | Delivery risk / customer satisfaction | High | Formal supplier performance review; evaluate dual-sourcing |
| Low-stock orders this week | 8 orders placed with <300 units on hand (Furniture, FMCG, Healthcare) | Stockout risk | Medium–High | Trigger replenishment review for flagged SKUs/warehouses |
| Rising order volume | +25.0% WoW order growth | Capacity strain risk | Medium | Confirm supplier & warehouse capacity can absorb demand |
| Long Sea-freight lead times | Sea ≈17.9 days vs Air ≈3.8 days | Working-capital / lead-time risk | Low–Medium | Reserve Sea freight for non-urgent replenishment only |
| Profit-margin field behaves atypically | Weekly Profit sometimes exceeds Total_Cost | Reporting integrity | Medium | Confirm with source system whether Profit is truly Revenue−Cost or an independently modeled field |

---

## H. Data Quality Rules Checked

- Missing dates: none · Duplicate Order_IDs: none · Missing Supplier/Product IDs: none
- Negative quantities/costs: none · Impossible dates (delivery before shipment, shipment before order): none
- Zero Unit_Price: 7 rows (retained, flagged for review)
- Negative Profit: 368 rows (~3.7% of orders) — kept, as negative profit on individual transactions is a valid business outcome, not a data error
