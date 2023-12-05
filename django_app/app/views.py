from django.shortcuts import render
from django.http import HttpResponse

def hello_view(request):
    return HttpResponse("Witaj w OKD 05.12.2023 14:00")