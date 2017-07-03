
# coding: utf-8

# In[49]:

from pulp import * 
import pandas as pd

dietdata = pd.read_excel("C:\\Users\\Dave\\Downloads\\diet_large.xls")
dietdata

dietdata = dietdata.values.tolist() #converts dataframe to list which is supposed to make the rest of the functionality easier 


# In[51]:

#extracting individual variables
foods = [x[1] for x in dietdata]
foods

#for x in dietdata:
#    print(x)
    
    
cost = dict([(x[1], float(x[2])) for x in dietdata])
#need to create a dict for each column 
calories
cholesterol 


# In[52]:

#Create a new LP problem 

prob = LpProblem('Food optimization', LpMinimize)
#This problem has 2 parameters "name" and "sense"

foodVars = LpVariable.dicts("Foods", foods, 0)
#Create variables with lower limit = 0

#for part 2 of question, food section must be 1/10 serving
food_select = LpVariable.dicts ("food_select", foods,0,1,LpBinary)


# In[53]:

#Objective function 
prob += lpSum([cost[f] * foodVars[f] for f in foods]), 'Total Cost'


# In[54]:

#Adding constraints

prob += lpSum([calories[f] * foodVars[f] for f in foods]) >= 1500, 'min Calories'
prob += lpSum([calories[f] * foodVars[f] for f in foods]) <= 2500, 'max Calories'


# In[55]:

prob.WriteLP("xyz.lp")
#solving the optimization problem
prob.solve()


# In[56]:

#printing the output
for var in prob.variables():
    if var.varValue > 0:
        print(str(var.varValue)+ " units of " + var.name)
        
print ("Total Cost of Ingredients = ", value(prob.objective))


# In[59]:

#adding secondary constraints

for food in foods:
    prob += foodVars[food] >= 0.1 * food_select[food]
    
#coercing foodVars_selected = 1 if foodVars selected
for food in foods: 
    prob += food_select[food] >= foodVars[food]*0.0000001
    
    


# In[58]:

#celery and Frozen brocolli constraint
prob += food_select['Frozen Brocolli'] + food_select['Celery, Raw'] <= 1


# In[ ]:

#solving the optimization problem 

prob.solve


# In[ ]:

for var in prob.variables():
    if var.varValue >0 and "food_select" not in var.name:
        print(str(var.varValue)+" units of " + var.name)

