# %%
import pandas as pd
import psycopg2 as pg
import sqlalchemy
from sqlalchemy import create_engine
import panel as pn

# %%
# Estabelecer conexão com o banco de dados
con = pg.connect(host='localhost', 
                 dbname='agente_saude', 
                 user='postgres', 
                 password='1234')

cnx = 'postgresql://postgres:1234@localhost:5432/agente_saude'
sqlalchemy.create_engine(cnx)

# %%
pn.extension()
pn.extension('tabulator')
pn.extension(notifications=True)

# %%
#campos de texto

#declare esta variável para usar na consulta de campos em branco
flag=''

#df = pd.DataFrame()

nome = pn.widgets.TextInput(
    name = "Nome",
    value='',
    placeholder='Digite o nome',
    disabled=False
)


buttonConsultar = pn.widgets.Button(name='Consultar', button_type='default')

# %%
# consultar        
# neste exemplo o método de consulta usa o dataframe do pandas como retorno. Note que a flag é usada para ignorar quando um 
# campo for null (condição é sempre verdadeira). Veja que para cpf, que é uma string, foi usado '{cpf.value})' como parametro
# e para dnr que é numérico, foi usado {dnr.value} (sem aspas simples).
def on_consultar():
    try:  
        query = f"select * from morador where ('{nome.value_input}'='{flag}' or nome='{nome.value_input}')"
        df = pd.read_sql_query(query, cnx)
        table = pn.widgets.Tabulator(df, layout='fit_data')
        return table
    except:
        return pn.pane.Alert('Não foi possível consultar!')

# %%
def table_creator(cons):
    if cons:
        return on_consultar()
    

interactive_table = pn.bind(table_creator, buttonConsultar)

# %%
pn.Column(nome,
       buttonConsultar,
       interactive_table).servable()


