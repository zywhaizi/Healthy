#!/usr/bin/env python3
import os, uuid

def uid():
    return uuid.uuid4().hex[:24].upper()

BASE = '/tmp/HealthCompanion/HealthCompanion'

src_files = [
    ('AppDelegate.h',  False),
    ('AppDelegate.m',  True),
    ('main.m',         True),
    ('Models/HCHealthDataModel.h', False),
    ('Models/HCHealthDataModel.m', True),
    ('Views/HCRingProgressView.h', False),
    ('Views/HCRingProgressView.m', True),
    ('Views/HCWaterView.h',        False),
    ('Views/HCWaterView.m',        True),
    ('Views/HCSleepBarView.h',     False),
    ('Views/HCSleepBarView.m',     True),
    ('Views/HCMoodTrendView.h',    False),
    ('Views/HCMoodTrendView.m',    True),
    ('Views/HCDashboardCardView.h',False),
    ('Views/HCDashboardCardView.m',True),
    ('Controllers/HCDashboardViewController.h', False),
    ('Controllers/HCDashboardViewController.m', True),
    ('Controllers/HCQuickAddViewController.h',  False),
    ('Controllers/HCQuickAddViewController.m',  True),
    ('Controllers/HCProfileViewController.h',   False),
    ('Controllers/HCProfileViewController.m',   True),
    ('Controllers/HCTabBarController.h',         False),
    ('Controllers/HCTabBarController.m',         True),
]

files = []
for relpath, compile in src_files:
    abspath = BASE + '/' + relpath
    files.append({
        'relpath': relpath,
        'abspath': abspath,
        'name': os.path.basename(relpath),
        'compile': compile,
        'file_id': uid(),
        'build_id': uid() if compile else None,
    })

PROJECT_ID          = uid()
TARGET_ID           = uid()
BUILD_CONF_LIST_PROJ= uid()
BUILD_CONF_LIST_TGT = uid()
DEBUG_CONF_PROJ     = uid()
RELEASE_CONF_PROJ   = uid()
DEBUG_CONF_TGT      = uid()
RELEASE_CONF_TGT    = uid()
SOURCES_PHASE_ID    = uid()
RES_PHASE_ID        = uid()
FRAMEWORKS_PHASE_ID = uid()
UIKIT_FILE_ID       = uid()
UIKIT_BUILD_ID      = uid()
FOUNDATION_FILE_ID  = uid()
FOUNDATION_BUILD_ID = uid()
PRODUCT_FILE_ID     = uid()
MAIN_GROUP_ID       = uid()
PRODUCTS_GROUP_ID   = uid()

L = []
L.append('// !$*UTF8*$!')
L.append('{')
L.append('\tarchiveVersion = 1;')
L.append('\tclasses = {};')
L.append('\tobjectVersion = 56;')
L.append('\tobjects = {')
L.append('')

# PBXBuildFile
L.append('/* Begin PBXBuildFile section */')
for f in files:
    if f['compile']:
        L.append(f'\t\t{f["build_id"]} /* {f["name"]} in Sources */ = {{isa = PBXBuildFile; fileRef = {f["file_id"]} /* {f["name"]} */; }};')
L.append(f'\t\t{UIKIT_BUILD_ID} /* UIKit.framework in Frameworks */ = {{isa = PBXBuildFile; fileRef = {UIKIT_FILE_ID}; }};')
L.append(f'\t\t{FOUNDATION_BUILD_ID} /* Foundation.framework in Frameworks */ = {{isa = PBXBuildFile; fileRef = {FOUNDATION_FILE_ID}; }};')
L.append('/* End PBXBuildFile section */')
L.append('')

# PBXFileReference - use absolute paths with <absolute> sourceTree
L.append('/* Begin PBXFileReference section */')
for f in files:
    n = f['name']
    if n.endswith('.h'):      ft = 'sourcecode.c.h'
    elif n.endswith('.m'):    ft = 'sourcecode.c.objc'
    elif n.endswith('.plist'):ft = 'text.plist.xml'
    else:                     ft = 'file'
    # Use absolute path
    L.append(f'\t\t{f["file_id"]} /* {n} */ = {{isa = PBXFileReference; lastKnownFileType = {ft}; name = "{n}"; path = "{f["abspath"]}"; sourceTree = "<absolute>"; }};')
L.append(f'\t\t{UIKIT_FILE_ID} /* UIKit.framework */ = {{isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = UIKit.framework; path = System/Library/Frameworks/UIKit.framework; sourceTree = SDKROOT; }};')
L.append(f'\t\t{FOUNDATION_FILE_ID} /* Foundation.framework */ = {{isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = Foundation.framework; path = System/Library/Frameworks/Foundation.framework; sourceTree = SDKROOT; }};')
L.append(f'\t\t{PRODUCT_FILE_ID} /* HealthCompanion.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = HealthCompanion.app; sourceTree = BUILT_PRODUCTS_DIR; }};')
L.append('/* End PBXFileReference section */')
L.append('')

# Frameworks
L.append('/* Begin PBXFrameworksBuildPhase section */')
L.append(f'\t\t{FRAMEWORKS_PHASE_ID} = {{isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = ({UIKIT_BUILD_ID},{FOUNDATION_BUILD_ID},); runOnlyForDeploymentPostprocessing = 0; }};')
L.append('/* End PBXFrameworksBuildPhase section */')
L.append('')

# Groups
L.append('/* Begin PBXGroup section */')
L.append(f'\t\t{MAIN_GROUP_ID} = {{isa = PBXGroup; children = (')
for f in files:
    L.append(f'\t\t\t{f["file_id"]},')
L.append(f'\t\t\t{UIKIT_FILE_ID},{FOUNDATION_FILE_ID},{PRODUCTS_GROUP_ID},')
L.append(f'\t\t); name = HealthCompanion; sourceTree = "<group>"; }};')
L.append(f'\t\t{PRODUCTS_GROUP_ID} = {{isa = PBXGroup; children = ({PRODUCT_FILE_ID},); name = Products; sourceTree = "<group>"; }};')
L.append('/* End PBXGroup section */')
L.append('')

# Native target
L.append('/* Begin PBXNativeTarget section */')
L.append(f'\t\t{TARGET_ID} = {{isa = PBXNativeTarget; buildConfigurationList = {BUILD_CONF_LIST_TGT}; buildPhases = ({SOURCES_PHASE_ID},{FRAMEWORKS_PHASE_ID},{RES_PHASE_ID},); buildRules = (); dependencies = (); name = HealthCompanion; productName = HealthCompanion; productReference = {PRODUCT_FILE_ID}; productType = "com.apple.product-type.application"; }};')
L.append('/* End PBXNativeTarget section */')
L.append('')

# Project
L.append('/* Begin PBXProject section */')
L.append(f'\t\t{PROJECT_ID} /* Project object */ = {{')
L.append('\t\t\tisa = PBXProject;')
L.append(f'\t\t\tattributes = {{LastUpgradeCheck = 1600; TargetAttributes = {{{TARGET_ID} = {{CreatedOnToolsVersion = 16.0;}};}};  }};')
L.append(f'\t\t\tbuildConfigurationList = {BUILD_CONF_LIST_PROJ};')
L.append('\t\t\tcompatibilityVersion = "Xcode 14.0";')
L.append('\t\t\tdevelopmentRegion = zh_CN;')
L.append('\t\t\thasScannedForEncodings = 0;')
L.append('\t\t\tknownRegions = (en, zh_CN, Base,);')
L.append(f'\t\t\tmainGroup = {MAIN_GROUP_ID};')
L.append(f'\t\t\tproductRefGroup = {PRODUCTS_GROUP_ID};')
L.append('\t\t\tprojectDirPath = "";')
L.append('\t\t\tprojectRoot = "";')
L.append(f'\t\t\ttargets = ({TARGET_ID},);')
L.append('\t\t};')
L.append('/* End PBXProject section */')
L.append('')

# Resources
L.append('/* Begin PBXResourcesBuildPhase section */')
INFO_ID = uid()
INFO_BUILD_ID = uid()
L.append(f'\t\t{RES_PHASE_ID} = {{isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; }};')
L.append('/* End PBXResourcesBuildPhase section */')
L.append('')

# Sources
L.append('/* Begin PBXSourcesBuildPhase section */')
L.append(f'\t\t{SOURCES_PHASE_ID} = {{isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (')
for f in files:
    if f['compile']:
        L.append(f'\t\t\t{f["build_id"]},')
L.append('); runOnlyForDeploymentPostprocessing = 0; };')
L.append('/* End PBXSourcesBuildPhase section */')
L.append('')

# Build configs
L.append('/* Begin XCBuildConfiguration section */')

def conf(cid, name, is_tgt):
    L.append(f'\t\t{cid} = {{isa = XCBuildConfiguration; buildSettings = {{')
    L.append('\t\t\tCLANG_ENABLE_MODULES = YES;')
    L.append('\t\t\tCLANG_ENABLE_OBJC_ARC = YES;')
    L.append('\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 15.0;')
    L.append('\t\t\tSDKROOT = iphoneos;')
    if is_tgt:
        L.append('\t\t\tCODE_SIGN_STYLE = Automatic;')
        L.append(f'\t\t\tINFOPLIST_FILE = "{BASE}/Info.plist";')
        L.append('\t\t\tPRODUCT_BUNDLE_IDENTIFIER = "com.healthcompanion.app";')
        L.append('\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";')
        L.append('\t\t\tTARGETED_DEVICE_FAMILY = "1,2";')
        L.append(f'\t\t\tHEADER_SEARCH_PATHS = "{BASE} {BASE}/Models {BASE}/Views {BASE}/Controllers";')
    if name == 'Debug':
        L.append('\t\t\tONLY_ACTIVE_ARCH = YES;')
        L.append('\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;')
    else:
        L.append('\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";')
        L.append('\t\t\tENABLE_NS_ASSERTIONS = NO;')
    L.append(f'\t\t}}; name = {name}; }};')

conf(DEBUG_CONF_PROJ,   'Debug',   False)
conf(RELEASE_CONF_PROJ, 'Release', False)
conf(DEBUG_CONF_TGT,    'Debug',   True)
conf(RELEASE_CONF_TGT,  'Release', True)
L.append('/* End XCBuildConfiguration section */')
L.append('')
L.append('/* Begin XCConfigurationList section */')
L.append(f'\t\t{BUILD_CONF_LIST_PROJ} = {{isa = XCConfigurationList; buildConfigurations = ({DEBUG_CONF_PROJ},{RELEASE_CONF_PROJ},); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};')
L.append(f'\t\t{BUILD_CONF_LIST_TGT} = {{isa = XCConfigurationList; buildConfigurations = ({DEBUG_CONF_TGT},{RELEASE_CONF_TGT},); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};')
L.append('/* End XCConfigurationList section */')
L.append('')
L.append('\t};')
L.append(f'\trootObject = {PROJECT_ID} /* Project object */;')
L.append('}')

os.makedirs('/tmp/HealthCompanion/HealthCompanion.xcodeproj', exist_ok=True)
out = '/tmp/HealthCompanion/HealthCompanion.xcodeproj/project.pbxproj'
with open(out, 'w') as fh:
    fh.write('\n'.join(L))
print('OK:', out)
