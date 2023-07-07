workspace "Voyager"
	architecture "x64"
	startproject "Sandbox"

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Voyager/vendor/GLFW/include"
IncludeDir["Glad"] = "Voyager/vendor/Glad/include"
IncludeDir["ImGui"] = "Voyager/vendor/imgui"
IncludeDir["glm"] = "Voyager/vendor/glm"

include "Voyager/vendor/GLFW"
include "Voyager/vendor/Glad"
include "Voyager/vendor/ImGui"

project "Voyager"
	location "Voyager"
	kind "SharedLib"
	language "C++"
	staticruntime "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "vgrpch.h"
	pchsource "Voyager/src/vgrpch.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.inl",
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.glm}"
	}

	links
	{
		"GLFW",
		"Glad",
		"ImGui",
		"opengl32.lib",
		"dwmapi.lib"
	}

	filter "system:windows"
		cppdialect "C++17"
		systemversion "latest"

		defines
		{
			"VGR_PLATFORM_WINDOWS",
			"VGR_BUILD_DLL",
			"GLFW_INCLUDE_NONE"
		}

		postbuildcommands
		{			
			 ("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/\"")
		}

	filter "configurations:Debug"
		defines "VGR_DEBUG"
		runtime "Debug"
		symbols "On"

	filter "configurations:Release"
		defines "VGR_RELEASE"
		runtime "Release"
		optimize "On"

	filter "configurations:Dist"
		defines "VGR_DIST"
		runtime "Release"
		optimize "On"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	staticruntime "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"Voyager/vendor/spdlog/include",
		"Voyager/src",
		"%{IncludeDir.glm}"
	}

	links
	{
		"Voyager"
	}

	filter "system:windows"
		cppdialect "C++17"
		systemversion "latest"

		defines
		{
			"VGR_PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		defines "VGR_DEBUG"
		runtime "Debug"
		symbols "On"

	filter "configurations:Release"
		defines "VGR_RELEASE"
		runtime "Release"
		optimize "On"

	filter "configurations:Dist"
		defines "VGR_DIST"
		runtime "Release"
		optimize "On"