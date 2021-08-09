from app import app

'''
from flask import request
from flask import jsonify
from flaskext.mysql import MySQL

app = Flask(__name__) #instancia
mysql=MySQL()

app.config['MYSQL_DATABASE_USER']='root'
app.config['MYSQL_DATABASE_PASSWORD']='gonzalito'
app.config['MYSQL_DATABASE_DB']='Silabo'
app.config['MYSQL_DATABASE_HOST']='127.0.0.1'
mysql.init_app(app)

con=mysql.connect()
cursor=con.cursor()


'''

if __name__=='__main__':
    app.run(debug=True,port=8000,host="0.0.0.0")

