int32_t -[ZoomSDKAuthService sdkAuth:](struct ZoomSDKAuthService* self, SEL sel, id sdkAuth)
    _objc_msgSend(_objc_msgSend(_OBJC_CLASS_$_ZMLogger, "getLogger"), "infoLog:moduleName:function:line…", _objc_msgSend(_OBJC_CLASS_$_NSString, "stringWithFormat:", &cfstr_), "ClientSDK", "-[ZoomSDKAuthService sdkAuth:]", 0x9a)
    return _objc_msgSend(+[ZoomSDKSinkEventMgr sharedInstance](clsRef_ZPSDKHelperAdapter, "sharedInstance"), "sdkAuth:") __tailcall

void -[ZoomSDK initSDK:](struct ZoomSDK* self, SEL sel, char initSDK)
    int64_t rax = *___stack_chk_guard
    uint32_t rax_1 = ssb::t2m_loglevel(2)
    char var_48 = 0
    char* rax_2 = _get_level_name(rax_1)
    _get_module_name(0x406)
    void var_940
    void var_848
    ssb::memlog_stream_t::memlog_stream_t(&var_940, &var_848, &__macho_section_64_[23].addr:1, rax_2)
    char var_a68
    char initSDK_1
    char var_880
    void* var_870
    char var_868
    void var_867
    uint64_t var_860
    void* var_858
    char* r13

    uint64_t rdx_1 = var_8b0
                    void* rax_8
                    uint64_t rdx_2
                    
                    if ((rdx_1.b & 1) == 0)
                        rdx_2 = rdx_1 u>> 1
                        void var_8af
                        rax_8 = &var_8af
                    else
                        rax_8 = var_8a0
                        uint64_t var_8a8
                        rdx_2 = var_8a8
                        
                    uint32_t i
                    
                    do
                        if (rdx_2 == 0)
                            rdx_2 = -1
                            break
                        
                        i = *(rax_8 + rdx_2 - 1)
                        rdx_2 -= 1
                        
                        if (i == 0x5c)
                            break
                    while (i != 0x2f)
                    std::string::string(&var_868, &var_8f8, rdx_2 + 1, -ffffffffffffffff)
                    r13 = nullptr
                    break
            
            r13.b = 1
            sub_30e0(&var_868, "/Users/zoom/Jenkins/workspace/Cl…")
            break

        uint64_t rdx_4 = var_868
        uint64_t rdx_5
        void* rsi_2
        
        if ((rdx_4.b & 1) == 0)
            rdx_5 = rdx_4 u>> 1
            rsi_2 = &var_867
        else
            rsi_2 = var_858
            rdx_5 = var_860
        
        int64_t* rax_13 = sub_4164(sub_4164(sub_4164(sub_4164(sub_4164(rax_5, rsi_2, rdx_5), &data_15e02c, 2), "-[ZoomSDK initSDK:]", 0x13), &data_15e043, 2), "[InitSDK] customizedFlag:", 0x19)
        initSDK_1 = initSDK
        sub_4164(sub_4164(rax_13, &initSDK_1, 1), &data_1618c7, 1)
        
        if ((var_868 & 1) != 0)
            operator delete(var_858)
        
        if (r13.b == 0)
            if ((var_8b0 & 1) != 0)
                operator delete(var_8a0)
            
            void* var_8e8
            
            if ((var_8f8 & 1) != 0)
                operator delete(var_8e8)

        if ((var_880 & 1) != 0)
        operator delete(var_870)

    logging::LogMessage::~LogMessage()
    std::locale* rax_18 = ssb::memlog_stream_t::operator<<(ssb::memlog_stream_t::operator<<(ssb::memlog_stream_t::operator<<(ssb::memlog_stream_t::operator<<(&var_940))))
    sub_30e0(&var_868, "/Users/zoom/Jenkins/workspace/Cl…")
    uint64_t rax_19 = var_868
    uint64_t rax_20
    void* rcx_3
    if ((rax_19.b & 1) == 0)
    rax_20 = rax_19 u>> 1
    rcx_3 = &var_867
    else
    rcx_3 = var_858
    rax_20 = var_860
    void* var_888
    while (true)
    if (rax_20 != 0)
        uint32_t rdx_6 = *(rcx_3 + rax_20 - 1)
        rax_20 -= 1

        if (rdx_6 != 0x5c && rdx_6 != 0x2f)
        continue

    if (rax_20 != -1)
        sub_30e0(&var_880, "/Users/zoom/Jenkins/workspace/Cl…")
        sub_30e0(&initSDK_1, "/Users/zoom/Jenkins/workspace/Cl…")
        uint64_t initSDK_2 = initSDK_1
        void* rax_21
        uint64_t rdx_7
        
        if ((initSDK_2.b & 1) == 0)
            rdx_7 = initSDK_2 u>> 1
            void var_897
            rax_21 = &var_897
        else
            rax_21 = var_888
            uint64_t var_890
            rdx_7 = var_890
        
        uint32_t i_1
        
        do
            if (rdx_7 == 0)
                rdx_7 = -1
                break

                i_1 = *(rax_21 + rdx_7 - 1)
                rdx_7 -= 1
                
                if (i_1 == 0x5c)
                    break
            while (i_1 != 0x2f)
            std::string::string(&var_a68, &var_880, rdx_7 + 1, -ffffffffffffffff)
            r13 = nullptr
            break

    r13.b = 1
    sub_30e0(&var_a68, "/Users/zoom/Jenkins/workspace/Cl…")
    break
    ssb::memlog_stream_t::operator<<(ssb::memlog_stream_t::operator<<(ssb::memlog_stream_t::operator<<(ssb::memlog_stream_t::operator<<(rax_18))))
    void* var_a58
    if ((var_a68 & 1) != 0)
    operator delete(var_a58)
    if (r13.b == 0)
    if ((initSDK_1 & 1) != 0)
        operator delete(var_888)

    if ((var_880 & 1) != 0)
    operator delete(var_870)
    if ((var_868 & 1) != 0)
        operator delete(var_858)
    char var_8e0
    sub_30e0(&var_8e0, &data_15e06e)
    ssb::memlog_stream_t::setSplit(&var_940)
    void* var_8d0
    if ((var_8e0 & 1) != 0)
        operator delete(var_8d0)
    ssb::memlog_stream_t::operator<<(ssb::memlog_stream_t::operator<<(&var_940))
    char var_8c8
    sub_30e0(&var_8c8, &cstr_)
    ssb::memlog_stream_t::setSplit(&var_940)
    void* var_8b8
    if ((var_8c8 & 1) != 0)
        operator delete(var_8b8)
    ssb::memlog_stream_t::operator<<(&var_940)
    ssb::MEMORY_LOG(0x406, rax_1, &var_940)
    void (* rdx_10)(int32_t) = ssb::memlog_stream_t::~memlog_stream_t()
    if (data_214a70 == 0)
        _signal(0x1f, sub_f13e4, _signal(0xd, sub_f13e4, rdx_10))
        self->_needCustomizedUI = initSDK

        if (sub_2aa0(1, 0xa, 0xe, 0) != 0)
            _objc_msgSend(*_NSApp, "addObserver:forKeyPath:options:c…", self, &cfstr_effectiveAppearance, 0, 0)
        
        -[ZoomSDK initSDK](data_214a68, "initSDK")
        -[ZoomSDKMeetingActionController initNotification](data_214a68, "initNotification")
        self->_authService = +[ZoomSDKSinkEventMgr sharedInstance](clsRef_ZoomSDKAuthService, "sharedInstance")
        self->_networkService = +[ZoomSDKSinkEventMgr sharedInstance](clsRef_ZoomSDKNetworkService, "sharedInstance")
        self->_enableRawdataIntermediateMode = 0
        self->_videoRawDataMode = 0
        self->_sha
    if (logging::GetMinLogLevel() s<= 2)
        logging::LogMessage::LogMessage(&var_a68, "/Users/zoom/Jenkins/workspace/Cl…", 0xb3)
        void var_a60
        int64_t* rax_5 = sub_4164(&var_a60, &data_15e02a, 1)
        sub_30e0(&var_880, "/Users/zoom/Jenkins/workspace/Cl…")
        uint64_t rax_6 = var_880
        uint64_t rax_7
        void* rcx_2
        
        if ((rax_6.b & 1) == 0)
            rax_7 = rax_6 u>> 1
            void var_87f
            rcx_2 = &var_87f
        else
            rcx_2 = var_870
            uint64_t var_878
            rax_7 = var_878
            
        char var_8f8
        char var_8b0
        void* var_8a0
        
        while (true)
            if (rax_7 != 0)
                uint32_t rdx = *(rcx_2 + rax_7 - 1)
                rax_7 -= 1
                
                if (rdx != 0x5c && rdx != 0x2f)
                    continue
                
                if (rax_7 != -1)
                    sub_30e0(&var_8f8, "/Users/zoom/Jenkins/workspace/Cl…")
                    sub_30e0(&var_8b0, "/Users/zoom/Jenkins/workspace/Cl…")
                reRawDataMode = 0
        self->_audioRawDataMode = 0
        data_214a70 = 1
        _objc_msgSend(_objc_msgSend(_OBJC_CLASS_$_ZMRouterCenter, "shared"), "registerSingleton:forProtocol:", +[ZoomSDKSinkEventMgr sharedInstance](clsRef_ZoomSDKMemoryHelper, "sharedInstance"), protoRef_IZoomSDKMemoryHelper)
    if (*___stack_chk_guard == rax)
        return 
    ___stack_chk_fail()
    noreturn