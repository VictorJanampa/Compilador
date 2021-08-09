from flask import Flask

app =Flask(__name__)


from app.modelos.Model import Model
from app.controladores import controlador