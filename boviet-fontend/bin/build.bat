@echo off
echo.
echo [��Ϣ] ��װWeb���̣�����dist�ļ���
echo.

%~d0
cd %~dp0

cd ..
npm run build:prod

pause