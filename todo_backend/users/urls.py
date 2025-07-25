from django.urls import path
from . import views

urlpatterns = [
    path('auth/google/', views.google_auth, name='google-auth'),
    path('profile/', views.user_profile, name='user-profile'),
]