import numpy as np 
import pandas as pd
import matplotlib.pyplot as plt 
import matplotlib.ticker as ticker
import matplotlib.colors as mcolors
import seaborn as sns
import pyodbc as py
print("If you have SQL server")
server_name = input("Please,Enter your server name: ")
con = py.connect("DRIVER={ODBC Driver 17 for SQL Server};"
    f"SERVER={server_name};"
    "DATABASE=OlismDB;"
    "Trusted_Connection=yes;")
def execute_quary_file(query_file): 
    dataframes = []
    with open(query_file,'r') as file:
         data_quality_file = file.read()
    queries_data_quality = [q.strip() for q in data_quality_file.split(';') if q.strip() and not q.strip().startswith('USE')]
    for query in queries_data_quality:
       df = pd.read_sql(query,con)
       dataframes.append(df)
    return dataframes   
           

tt1 = execute_quary_file(r"..\SQL\TT1.sql")
tt2 = execute_quary_file(r"..\SQL\TT2.sql")


query_RFM = tt1[6]
df_RFM = pd.DataFrame()
df_RFM['customer_unique_id'] = query_RFM['customer_unique_id']
df_RFM['R_score'] = pd.qcut(query_RFM['diff_days_to_last_purchase'],q=5,labels=[5,4,3,2,1])
df_RFM['F_score'] = pd.cut(query_RFM['num_customer_orders'],bins=[float('-inf'),1,2,3,5,float('inf')],labels=[1,2,3,4,5])
df_RFM['M_score'] = pd.qcut(query_RFM['customer_spending'],q=5,labels=[1,2,3,4,5])
def assign_segment(row):
    r = int(row['R_score'])
    f = int(row['F_score'])
    m = int(row['M_score'])
   
    if r == 5 and f >= 4 and m >= 4:
        return 'Champions'
    
    elif r >= 3 and f >= 3 and m >= 3:
        return 'Loyal Customers'
    
  
    elif r >= 4 and f <= 2 and m >= 3:
        return 'Potential Loyalists'
    
  
    elif r == 5 and f <= 2:
        return 'New Customers'
    
  
    elif r in [2, 3] and f >= 3:
        return 'At Risk'
    
  
    elif r <= 2 and f >= 4 and m >= 4:
        return 'Cant Lose Them'
    
  
    elif r <= 2 and f <= 2:
        return 'Lost Customers'

    else:
        return 'About to Sleep'
df_RFM['Segment'] = df_RFM.apply(assign_segment,axis=1)
total_segement = df_RFM['Segment'].value_counts()
print(total_segement)
print(100*'#')
df_review_service = tt2[5].dropna()
corr_review_service = df_review_service[['Actual_Delivery_Days','delay_days','cost','review_score']].corr(method='pearson')
print(corr_review_service['review_score'])
print(100*'#')

new_cutomer = tt2[6]
cohort_counts = new_cutomer.pivot(index='cohort_month', columns='CohortIndex', values='total_customers')
cohort_sizes = cohort_counts.iloc[:, 0]
retention = cohort_counts.divide(cohort_sizes, axis=0).round(4) * 100
for i in range(len(retention)):
    max_past_months = len(retention) - i
    retention.iloc[i, :max_past_months] = retention.iloc[i, :max_past_months].fillna(0)
print(retention)

monthly_sales = tt1[3]
sns.set_theme(style='dark',rc={'axes.facecolor': '#121212', 'figure.facecolor': '#121212'})
plt.figure(figsize=(12,6))
line_chart = sns.lineplot(data=monthly_sales,x='month_date',y='month_sales',marker='o',color='#00e5ff',linewidth=2.5,markersize=6)
formatter_y = ticker.FuncFormatter(lambda x,pos: f'{x:,.0f}')
line_chart.yaxis.set_major_formatter(formatter_y)
plt.grid(True,linestyle='-',alpha=0.15)
plt.xticks(rotation=45, ha='right',color='#444444',fontsize=10)
plt.xlabel('month_date',color='#444444',fontsize=11,fontweight='bold')
plt.yticks(color='#444444',fontsize=10)
plt.ylabel('month_sales',color='#444444',fontsize=11,fontweight='bold')
plt.title('Monthly Sales',fontweight='bold')
for spine in line_chart.spines.values():
    spine.set_color('#444444')
plt.tight_layout()


top_categories = tt1[5]
sns.set_theme(style='dark',rc={'axes.facecolor': '#121212', 'figure.facecolor': '#121212'})
plt.figure(figsize=(12,6))
bar_chart1 = sns.barplot(data=top_categories,x='Best_selling_category',y='category', color='#00e5ff')
formatter_bar1_x = ticker.FuncFormatter(lambda x,pos: f'{x:,.0f}')
bar_chart1.xaxis.set_major_formatter(formatter_bar1_x)
plt.grid(True,linestyle='-',alpha=0.15)
plt.xticks(rotation=45, ha='right',color='#444444',fontsize=10)
plt.xlabel('Best_selling_category',color='#444444',fontsize=11,fontweight='bold')
plt.yticks(color='#444444',fontsize=10)
plt.ylabel('category',color='#444444',fontsize=11,fontweight='bold')
plt.title('Best 10 categories sales',fontweight='bold')
for spine in bar_chart1.spines.values(): 
    spine.set_color('#444444')
plt.tight_layout()

state_sales = tt1[7].head(10)
sns.set_theme(style='dark',rc={'axes.facecolor': '#121212', 'figure.facecolor': '#121212'})
plt.figure(figsize=(12,6))
bar_chart2 = sns.barplot(data=state_sales,x='customer_state',y='sales_state',color='#00e5ff')
formatter_bar2_y = ticker.FuncFormatter(lambda x,pos: f'{x:,.0f}')
bar_chart2.yaxis.set_major_formatter(formatter_bar2_y)
plt.grid(True,linestyle='-',alpha=0.15)
plt.xticks(rotation=45, ha='right',color='#444444',fontsize=10)
plt.xlabel('customer_state',color='#444444',fontsize=11,fontweight='bold')
plt.yticks(color='#444444',fontsize=10)
plt.ylabel('sales_state',color='#444444',fontsize=11,fontweight='bold')
plt.title('Best 10 states sales',fontweight='bold')
for spine in bar_chart2.spines.values():
    spine.set_color('#444444')
plt.tight_layout()

colors = [ '#00e5ff',"#0088aa", "#397999","#1D2A37" ] 
custom_cmap = mcolors.LinearSegmentedColormap.from_list("turq_cmap", colors)

sns.set_theme(style='dark',rc={'axes.facecolor': '#121212', 'figure.facecolor': '#121212'})
plt.figure(figsize=(12,6))
heatmap1 = sns.heatmap(retention,annot=True,fmt='.2f',cmap=custom_cmap,linewidths=0.5,linecolor='#444444',annot_kws={'size':9,'weight':'bold','color':'#484545'})
formatter_heatmap1 = ticker.FuncFormatter(lambda x,pos: f'{x:,.0f}')
heatmap1.xaxis.set_major_formatter(formatter_heatmap1)
plt.grid(True,linestyle='-',alpha=0.15)
plt.yticks(rotation=45, ha='right',color='#444444',fontsize=10)
plt.ylabel('Cohort Month',color='#444444',fontsize=11,fontweight='bold')
plt.xlabel('Cohort Index',color='#444444',fontsize=11,fontweight='bold')
plt.xticks(color='#444444',fontsize=10)
plt.title('heatmap correlation cohort months',fontweight='bold')
for spine in heatmap1.spines.values():
    spine.set_color('#444444')
plt.tight_layout()



sns.set_theme(style='dark',rc={'axes.facecolor': '#121212', 'figure.facecolor': '#121212'})
plt.figure(figsize=(12,6))
heatmap2 = sns.heatmap(corr_review_service,annot=True,fmt='.2f',cmap=custom_cmap,linewidths=0.5,linecolor='#444444',annot_kws={'size':9,'weight':'bold','color':"#484545"})
formatter_heatmap2 = ticker.FuncFormatter(lambda x,pos: f'{x:,.0f}')
heatmap2.xaxis.set_major_formatter(formatter_heatmap2)
plt.grid(True,linestyle='-',alpha=0.15)
plt.yticks(color='#444444',fontsize=10)
plt.xlabel('correlation_services',color='#444444',fontsize=11,fontweight='bold')
plt.yticks(color='#444444',fontsize=10)
plt.ylabel('correlation_services',color='#444444',fontsize=11,fontweight='bold')
plt.title('heatmap correlation services',fontweight='bold')
for spine in heatmap2.spines.values():
    spine.set_color('#444444')
plt.tight_layout()
plt.show()
con.close()