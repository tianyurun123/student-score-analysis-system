from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.scores.views import (
    ScoreViewSet, ScoreImportLogViewSet, ScoreAdjustmentViewSet, 
    GradebookViewSet
)

router = DefaultRouter()
router.register(r'scores', ScoreViewSet, basename='score')
router.register(r'score-import-logs', ScoreImportLogViewSet, basename='score-import-log')
router.register(r'score-adjustments', ScoreAdjustmentViewSet, basename='score-adjustment')
router.register(r'gradebooks', GradebookViewSet, basename='gradebook')

urlpatterns = [
    path('', include(router.urls)),
]

