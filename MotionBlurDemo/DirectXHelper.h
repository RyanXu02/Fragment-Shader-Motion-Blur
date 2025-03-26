#pragma once

// Windows and Standard Headers
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <wrl/client.h>

// DirectX Headers
#include <d3d11.h>
#include <dxgi.h>
#include <d3dcompiler.h>

// Link necessary libraries
#pragma comment(lib, "d3d11.lib")
#pragma comment(lib, "dxgi.lib")
#pragma comment(lib, "d3dcompiler.lib")