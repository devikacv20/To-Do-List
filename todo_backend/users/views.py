from django.contrib.auth import login
from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from google.auth.transport import requests
from google.oauth2 import id_token
from django.conf import settings

@api_view(['POST'])
@permission_classes([AllowAny])
def google_auth(request):
    token = request.data.get('token')
    
    try:
        # Verify the token
        idinfo = id_token.verify_oauth2_token(
            token, requests.Request(), settings.GOOGLE_CLIENT_ID
        )
        
        email = idinfo['email']
        name = idinfo['name']
        
        # Get or create user
        user, created = User.objects.get_or_create(
            email=email,
            defaults={
                'username': email,
                'first_name': idinfo.get('given_name', ''),
                'last_name': idinfo.get('family_name', ''),
            }
        )
        
        # Login user
        login(request, user)
        
        return Response({
            'user_id': user.id,
            'email': user.email,
            'name': user.get_full_name(),
            'message': 'Login successful'
        })
        
    except ValueError:
        return Response(
            {'error': 'Invalid token'}, 
            status=status.HTTP_400_BAD_REQUEST
        )

@api_view(['GET'])
def user_profile(request):
    if request.user.is_authenticated:
        return Response({
            'user_id': request.user.id,
            'email': request.user.email,
            'name': request.user.get_full_name(),
        })
    return Response({'error': 'Not authenticated'}, status=status.HTTP_401_UNAUTHORIZED)