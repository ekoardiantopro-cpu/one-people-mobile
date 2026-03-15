import Foundation

enum OnePeopleMockData {
    static let profile = EmployeeProfile(
        employeeID: "0000000583",
        fullName: "Eko Ardianto",
        role: "IT Support Officer",
        department: "IT Support",
        company: "PT. Ekozer",
        location: "Jakarta Office",
        manager: "Budi Santoso",
        email: "eko.ardianto@ekozer.co.id",
        phone: "+62 813-9000-0583",
        shift: "Non Shift",
        annualLeaveBalance: 8
    )

    static let metrics: [DashboardMetric] = [
        DashboardMetric(id: "attendance", title: "Today Status", value: "Checked In", subtitle: "07:58 WIB", icon: "person.badge.clock.fill", colorHex: "#0E7490"),
        DashboardMetric(id: "leave", title: "Leave Balance", value: "8 Days", subtitle: "Annual leave remaining", icon: "calendar.badge.clock", colorHex: "#2AA6BA"),
        DashboardMetric(id: "overtime", title: "Overtime", value: "12.5 H", subtitle: "This month total", icon: "clock.arrow.circlepath", colorHex: "#B45309"),
        DashboardMetric(id: "payroll", title: "Payroll", value: "Ready", subtitle: "Slip gaji Maret tersedia", icon: "wallet.pass.fill", colorHex: "#7C3AED")
    ]

    static let announcements: [Announcement] = []

    static let attendanceHistory: [AttendanceRecord] = [
        AttendanceRecord(id: "at1", date: date(daysAgo: 0), checkIn: "-", checkOut: "-", workHours: "-", status: .present, location: "Jakarta Office"),
        AttendanceRecord(id: "at2", date: date(daysAgo: 1), checkIn: "08:03", checkOut: "17:11", workHours: "09h 08m", status: .late, location: "Main Office"),
        AttendanceRecord(id: "at3", date: date(daysAgo: 2), checkIn: "07:42", checkOut: "17:05", workHours: "09h 23m", status: .present, location: "Main Office"),
        AttendanceRecord(id: "at4", date: date(daysAgo: 3), checkIn: "07:55", checkOut: "16:48", workHours: "08h 53m", status: .remote, location: "Remote Camp"),
        AttendanceRecord(id: "at5", date: date(daysAgo: 4), checkIn: "-", checkOut: "-", workHours: "-", status: .dayOff, location: "Off Duty")
    ]

    static let leaveRequests: [LeaveRequest] = [
        LeaveRequest(id: "lv1", title: "Annual Leave", type: "Annual Leave", startDateText: "24 Mar 2026", endDateText: "26 Mar 2026", durationText: "3 Days", reason: "Keperluan keluarga", status: .pending),
        LeaveRequest(id: "lv2", title: "Sick Leave", type: "Sick Leave", startDateText: "03 Feb 2026", endDateText: "04 Feb 2026", durationText: "2 Days", reason: "Demam dan observasi dokter", status: .approved),
        LeaveRequest(id: "lv3", title: "Roster Adjustment", type: "Special Leave", startDateText: "10 Jan 2026", endDateText: "10 Jan 2026", durationText: "1 Day", reason: "Perpindahan jadwal kerja", status: .rejected)
    ]

    static let approvals: [ApprovalItem] = [
        ApprovalItem(id: "ap1", requester: "Dimas Saputra", title: "Perubahan Shift", detail: "Swap roster dengan Andri Kurniawan", submittedAt: "13 Mar 2026", status: .approved),
        ApprovalItem(id: "ap2", requester: "Siti Maulida", title: "Izin Medical Check Up", detail: "1 hari, 11 Mar 2026", submittedAt: "11 Mar 2026", status: .approved),
        ApprovalItem(id: "ap3", requester: "Reza Fadillah", title: "Koreksi Kehadiran", detail: "Penyesuaian jam masuk 08:12 menjadi 07:58", submittedAt: "09 Mar 2026", status: .rejected)
    ]

    static let payslips: [Payslip] = [
        Payslip(id: "py1", month: "Maret 2026", payDate: "25 Mar 2026", grossSalary: "Rp 12.500.000", deductions: "Rp 2.500.000", takeHomePay: "Rp 10.000.000"),
        Payslip(id: "py2", month: "Februari 2026", payDate: "25 Feb 2026", grossSalary: "Rp 12.350.000", deductions: "Rp 2.350.000", takeHomePay: "Rp 10.000.000"),
        Payslip(id: "py3", month: "Januari 2026", payDate: "25 Jan 2026", grossSalary: "Rp 12.180.000", deductions: "Rp 2.180.000", takeHomePay: "Rp 10.000.000")
    ]

    static let services: [ServiceMenu] = [
        ServiceMenu(id: "srv1", title: "Leave Request", subtitle: "Ajukan cuti atau izin", icon: "airplane.departure"),
        ServiceMenu(id: "srv2", title: "Attendance History", subtitle: "Lihat riwayat absensi", icon: "calendar"),
        ServiceMenu(id: "srv3", title: "Payroll", subtitle: "Slip gaji dan rincian", icon: "creditcard.fill"),
        ServiceMenu(id: "srv4", title: "Approval Inbox", subtitle: "Persetujuan bawahan", icon: "checkmark.message.fill"),
        ServiceMenu(id: "srv5", title: "Employee Directory", subtitle: "Kontak tim dan atasan", icon: "person.3.fill"),
        ServiceMenu(id: "srv6", title: "Training", subtitle: "Modul pembelajaran internal", icon: "graduationcap.fill")
    ]

    static let homeShortcuts: [HomeShortcut] = [
        HomeShortcut(id: "sc1", title: "Absensi", icon: "person.badge.plus", tintHex: "#7A4E16", backgroundHex: "#FFF1D6", feature: .attendance),
        HomeShortcut(id: "sc2", title: "Izin", icon: "bag.fill", tintHex: "#AE1972", backgroundHex: "#FDE7F3", feature: .leave),
        HomeShortcut(id: "sc3", title: "Lap. Kehadiran", icon: "doc.text.magnifyingglass", tintHex: "#B3470D", backgroundHex: "#FFE8E1", feature: .attendanceReport),
        HomeShortcut(id: "sc4", title: "AI HR", icon: "sparkles", tintHex: "#4F80E1", backgroundHex: "#EAF1FF", feature: .aiAssistant)
    ]

    static let allMenus: [HomeShortcut] = [
        HomeShortcut(id: "menu1", title: "Absensi", icon: "person.badge.plus", tintHex: "#7A4E16", backgroundHex: "#FFF1D6", feature: .attendance),
        HomeShortcut(id: "menu2", title: "Approval", icon: "list.bullet", tintHex: "#7C3AED", backgroundHex: "#F1E8FF", feature: .approval),
        HomeShortcut(id: "menu3", title: "Aset", icon: "archivebox", tintHex: "#B42318", backgroundHex: "#FFE8EC", feature: .asset),
        HomeShortcut(id: "menu4", title: "Izin", icon: "briefcase", tintHex: "#AE1972", backgroundHex: "#FDE7F3", feature: .leave),
        HomeShortcut(id: "menu5", title: "Laporan Kehadiran", icon: "doc.text", tintHex: "#B3470D", backgroundHex: "#FFE8E1", feature: .attendanceReport),
        HomeShortcut(id: "menu6", title: "Roster", icon: "door.left.hand.open", tintHex: "#1D4ED8", backgroundHex: "#E0F2FE", feature: .roster),
        HomeShortcut(id: "menu7", title: "Slip Gaji", icon: "banknote", tintHex: "#2AA6BA", backgroundHex: "#E7F7FA", feature: .payslip),
        HomeShortcut(id: "menu8", title: "Skill Inventory", icon: "person.2.badge.gearshape", tintHex: "#0E7490", backgroundHex: "#E0F7FF", feature: .skillInventory),
        HomeShortcut(id: "menu9", title: "Project Marketplace", icon: "rectangle.3.group.bubble.left", tintHex: "#8B5CF6", backgroundHex: "#F0EBFF", feature: .projectMarketplace),
        HomeShortcut(id: "menu10", title: "AI HR Assistant", icon: "sparkles", tintHex: "#4F80E1", backgroundHex: "#EAF1FF", feature: .aiAssistant)
    ]

    static let profileMenus: [ProfileMenuItem] = [
        ProfileMenuItem(id: "pm1", title: "Data Pribadi", icon: "person.crop.circle"),
        ProfileMenuItem(id: "pm2", title: "Data Perusahaan", icon: "building.2"),
        ProfileMenuItem(id: "pm3", title: "Alamat", icon: "house"),
        ProfileMenuItem(id: "pm4", title: "Kontak Darurat", icon: "phone"),
        ProfileMenuItem(id: "pm5", title: "Keluarga", icon: "person.3"),
        ProfileMenuItem(id: "pm6", title: "Pendidikan", icon: "graduationcap")
    ]

    static let settingsItems: [SettingsItem] = [
        SettingsItem(id: "set1", title: "Ubah Kata Sandi", icon: "key.fill", showsToggle: false),
        SettingsItem(id: "set2", title: "Ubah Server", icon: "externaldrive.fill", showsToggle: false),
        SettingsItem(id: "set3", title: "Troubleshooting", icon: "wrench.and.screwdriver.fill", showsToggle: false),
        SettingsItem(id: "set4", title: "Biometric", icon: "lock.fill", showsToggle: true)
    ]

    static let messages: [MessageItem] = [
        MessageItem(id: "msg1", sender: "One People System", subject: "Persetujuan Cuti", preview: "Pengajuan cuti Anda sedang menunggu approval atasan.", time: "08:45"),
        MessageItem(id: "msg2", sender: "Payroll", subject: "Slip Gaji Tersedia", preview: "Slip gaji bulan Maret sudah dapat diunduh.", time: "Kemarin"),
        MessageItem(id: "msg3", sender: "Admin Site", subject: "Update Roster", preview: "Roster shift minggu depan telah diperbarui.", time: "12 Mar")
    ]

    static let attendanceTimeline: [AttendanceTimelineEntry] = [
        AttendanceTimelineEntry(id: "tl1", dateLabel: "26 Feb 2026", checkInText: "26 Feb 2026 | 06:58:51", checkOutText: "26 Feb 2026 | 18:13:06", location: "JANJI JIWA"),
        AttendanceTimelineEntry(id: "tl2", dateLabel: "27 Feb 2026", checkInText: "27 Feb 2026 | 06:54:11", checkOutText: "27 Feb 2026 | 18:07:11", location: "JANJI JIWA"),
        AttendanceTimelineEntry(id: "tl3", dateLabel: "28 Feb 2026", checkInText: "28 Feb 2026 | 06:30:11", checkOutText: "28 Feb 2026 | 18:38:01", location: "JANJI JIWA")
    ]

    static let attendanceReportRows: [AttendanceReportRow] = [
        AttendanceReportRow(id: "rp1", dayLabel: "01", checkIn: "Libur/Cuti Roster", checkOut: "", overtime: "0", dt: "0", pc: "0", isRosterOff: true),
        AttendanceReportRow(id: "rp2", dayLabel: "02", checkIn: "06:21:13", checkOut: "18:34:31", overtime: "1", dt: "0", pc: "0", isRosterOff: false),
        AttendanceReportRow(id: "rp3", dayLabel: "03", checkIn: "06:40:13", checkOut: "18:24:20", overtime: "0.5", dt: "0", pc: "0", isRosterOff: false),
        AttendanceReportRow(id: "rp4", dayLabel: "04", checkIn: "06:52:21", checkOut: "18:01:23", overtime: "0.5", dt: "0", pc: "0", isRosterOff: false),
        AttendanceReportRow(id: "rp5", dayLabel: "05", checkIn: "06:05:52", checkOut: "18:14:00", overtime: "0.5", dt: "0", pc: "0", isRosterOff: false),
        AttendanceReportRow(id: "rp6", dayLabel: "06", checkIn: "06:27:22", checkOut: "18:10:35", overtime: "0.5", dt: "0", pc: "0", isRosterOff: false),
        AttendanceReportRow(id: "rp7", dayLabel: "07", checkIn: "06:55:04", checkOut: "18:22:21", overtime: "0.5", dt: "0", pc: "0", isRosterOff: false),
        AttendanceReportRow(id: "rp8", dayLabel: "08", checkIn: "Libur/Cuti Roster", checkOut: "", overtime: "0", dt: "0", pc: "0", isRosterOff: true),
        AttendanceReportRow(id: "rp9", dayLabel: "09", checkIn: "06:22:34", checkOut: "18:10:23", overtime: "0.5", dt: "0", pc: "0", isRosterOff: false),
        AttendanceReportRow(id: "rp10", dayLabel: "10", checkIn: "06:39:20", checkOut: "18:10:19", overtime: "0.5", dt: "0", pc: "0", isRosterOff: false)
    ]

    static let attendanceCalendarMarkers: [CalendarDayMarker] = [
        CalendarDayMarker(id: "ac1", day: 1, state: .off),
        CalendarDayMarker(id: "ac2", day: 2, state: .present),
        CalendarDayMarker(id: "ac3", day: 3, state: .present),
        CalendarDayMarker(id: "ac4", day: 4, state: .present),
        CalendarDayMarker(id: "ac5", day: 5, state: .present),
        CalendarDayMarker(id: "ac6", day: 6, state: .present),
        CalendarDayMarker(id: "ac7", day: 7, state: .present),
        CalendarDayMarker(id: "ac8", day: 8, state: .off),
        CalendarDayMarker(id: "ac9", day: 9, state: .present),
        CalendarDayMarker(id: "ac10", day: 10, state: .present),
        CalendarDayMarker(id: "ac11", day: 11, state: .present),
        CalendarDayMarker(id: "ac12", day: 12, state: .present)
    ]

    static let rosterMarkers: [CalendarDayMarker] = [
        CalendarDayMarker(id: "rs1", day: 1, state: .off),
        CalendarDayMarker(id: "rs2", day: 2, state: .present),
        CalendarDayMarker(id: "rs3", day: 3, state: .present),
        CalendarDayMarker(id: "rs4", day: 4, state: .present),
        CalendarDayMarker(id: "rs5", day: 5, state: .present),
        CalendarDayMarker(id: "rs6", day: 6, state: .present),
        CalendarDayMarker(id: "rs7", day: 7, state: .present),
        CalendarDayMarker(id: "rs8", day: 8, state: .off),
        CalendarDayMarker(id: "rs9", day: 9, state: .present),
        CalendarDayMarker(id: "rs10", day: 10, state: .present),
        CalendarDayMarker(id: "rs11", day: 11, state: .present),
        CalendarDayMarker(id: "rs12", day: 12, state: .present),
        CalendarDayMarker(id: "rs13", day: 13, state: .present),
        CalendarDayMarker(id: "rs14", day: 14, state: .present),
        CalendarDayMarker(id: "rs15", day: 15, state: .off),
        CalendarDayMarker(id: "rs16", day: 16, state: .present),
        CalendarDayMarker(id: "rs17", day: 17, state: .present),
        CalendarDayMarker(id: "rs18", day: 18, state: .present),
        CalendarDayMarker(id: "rs19", day: 19, state: .present),
        CalendarDayMarker(id: "rs20", day: 20, state: .present),
        CalendarDayMarker(id: "rs21", day: 21, state: .present),
        CalendarDayMarker(id: "rs22", day: 22, state: .off),
        CalendarDayMarker(id: "rs23", day: 23, state: .present),
        CalendarDayMarker(id: "rs24", day: 24, state: .present),
        CalendarDayMarker(id: "rs25", day: 25, state: .present)
    ]

    static let assets: [AssetRecord] = [
        AssetRecord(id: "as1", title: "Mess & Office Container Site", subtitle: "1 Unit", unitText: "1 Aset", icon: "shippingbox", tintHex: "#FF7A45")
    ]

    static let assetTransfers: [AssetTransferRecord] = [
        AssetTransferRecord(id: "tr1", title: "Laptop Dell Latitude 5430", detail: "Transfer dari HO ke Site Support", dateText: "10 Mar 2026"),
        AssetTransferRecord(id: "tr2", title: "Projector Epson EB-X06", detail: "Dipindahkan ke ruang meeting operasional", dateText: "28 Feb 2026")
    ]

    static let payrollSections: [PayrollSection] = [
        PayrollSection(
            id: "pay1",
            title: "Penghasilan",
            icon: "banknote",
            tintHex: "#2AA6BA",
            lines: [
                PayrollLineItem(id: "inc1", title: "Gaji Pokok", amount: "Rp. 8,500,000.00"),
                PayrollLineItem(id: "inc2", title: "Tunjangan Jabatan", amount: "Rp. 2,000,000.00"),
                PayrollLineItem(id: "inc3", title: "Tunjangan Operasional", amount: "Rp. 1,650,000.00")
            ],
            totalLabel: "Total Penghasilan",
            totalAmount: "Rp. 12,150,000.00",
            totalTintHex: "#111111"
        ),
        PayrollSection(
            id: "pay2",
            title: "Potongan",
            icon: "banknote",
            tintHex: "#E11D48",
            lines: [
                PayrollLineItem(id: "ded1", title: "Pajak Pph 21", amount: "Rp. 350,000.00"),
                PayrollLineItem(id: "ded2", title: "Jaminan Hari Tua 2%", amount: "Rp. 170,000.00"),
                PayrollLineItem(id: "ded3", title: "Jaminan Pensiun 1%", amount: "Rp. 85,000.00"),
                PayrollLineItem(id: "ded4", title: "BPJS Kesehatan 1%", amount: "Rp. 85,000.00"),
                PayrollLineItem(id: "ded5", title: "Potongan Kehadiran", amount: "Rp. 1,460,000.00")
            ],
            totalLabel: "Total Potongan",
            totalAmount: "Rp. 2,150,000.00",
            totalTintHex: "#FF0000"
        )
    ]

    static let skillProfiles: [EmployeeSkillProfile] = [
        EmployeeSkillProfile(
            id: "sp1",
            employeeId: "0000000583",
            fullName: "Eko Ardianto",
            email: "eko.ardianto@ekozer.co.id",
            department: "IT Support",
            position: "IT Support Officer",
            skills: [
                SkillRecord(id: "sk1", skillName: "IT Support", category: "Infrastructure", type: .hardSkill, level: .expert),
                SkillRecord(id: "sk2", skillName: "Network Troubleshooting", category: "Infrastructure", type: .hardSkill, level: .advanced),
                SkillRecord(id: "sk3", skillName: "Asset Management", category: "Operations", type: .hardSkill, level: .advanced),
                SkillRecord(id: "sk4", skillName: "Customer Service", category: "People", type: .softSkill, level: .advanced),
                SkillRecord(id: "sk5", skillName: "Problem Solving", category: "People", type: .softSkill, level: .expert)
            ],
            certifications: [
                CertificationRecord(id: "cert1", title: "MTCNA", issuer: "MikroTik", yearText: "2024"),
                CertificationRecord(id: "cert2", title: "ITIL Foundation", issuer: "PeopleCert", yearText: "2023")
            ],
            projectExperience: [
                ProjectExperienceRecord(id: "exp1", projectName: "Service Desk Revamp", role: "Lead Support", summary: "Menyusun SOP incident handling dan dashboard SLA.", yearText: "2025"),
                ProjectExperienceRecord(id: "exp2", projectName: "Site Connectivity Upgrade", role: "Network PIC", summary: "Upgrade konektivitas site dan monitoring jaringan.", yearText: "2024")
            ],
            careerInterest: ["IT Infrastructure Lead", "IT Service Management", "Project Coordination"],
            createdAt: "02 Jan 2025",
            updatedAt: "15 Mar 2026"
        ),
        EmployeeSkillProfile(
            id: "sp2",
            employeeId: "0000000612",
            fullName: "Nadia Permata",
            email: "nadia.permata@ekozer.co.id",
            department: "Finance",
            position: "Finance Analyst",
            skills: [
                SkillRecord(id: "sk6", skillName: "Financial Modeling", category: "Finance", type: .hardSkill, level: .advanced),
                SkillRecord(id: "sk7", skillName: "Excel", category: "Analytics", type: .hardSkill, level: .expert),
                SkillRecord(id: "sk8", skillName: "Data Visualization", category: "Analytics", type: .hardSkill, level: .intermediate),
                SkillRecord(id: "sk9", skillName: "Stakeholder Communication", category: "People", type: .softSkill, level: .advanced)
            ],
            certifications: [
                CertificationRecord(id: "cert3", title: "Brevet A & B", issuer: "Ikatan Konsultan Pajak", yearText: "2022")
            ],
            projectExperience: [
                ProjectExperienceRecord(id: "exp3", projectName: "Digital Budget Monitoring", role: "Business Analyst", summary: "Mendesain dashboard anggaran real-time untuk site dan HO.", yearText: "2025")
            ],
            careerInterest: ["Data Analyst", "Finance Business Partner"],
            createdAt: "19 Feb 2025",
            updatedAt: "14 Mar 2026"
        ),
        EmployeeSkillProfile(
            id: "sp3",
            employeeId: "0000000731",
            fullName: "Rizky Ramadhan",
            email: "rizky.ramadhan@ekozer.co.id",
            department: "Operations",
            position: "Production Engineer",
            skills: [
                SkillRecord(id: "sk10", skillName: "Mine Planning", category: "Operations", type: .hardSkill, level: .expert),
                SkillRecord(id: "sk11", skillName: "Power BI", category: "Analytics", type: .hardSkill, level: .advanced),
                SkillRecord(id: "sk12", skillName: "SQL", category: "Analytics", type: .hardSkill, level: .intermediate),
                SkillRecord(id: "sk13", skillName: "Leadership", category: "People", type: .softSkill, level: .advanced)
            ],
            certifications: [
                CertificationRecord(id: "cert4", title: "POP", issuer: "BNSP", yearText: "2021")
            ],
            projectExperience: [
                ProjectExperienceRecord(id: "exp4", projectName: "Dispatch Optimization", role: "Process Improvement", summary: "Meningkatkan utilisasi alat dengan analisis data operasi harian.", yearText: "2025")
            ],
            careerInterest: ["Operations Superintendent", "Data-Driven Planning"],
            createdAt: "12 Mar 2025",
            updatedAt: "13 Mar 2026"
        ),
        EmployeeSkillProfile(
            id: "sp4",
            employeeId: "0000000890",
            fullName: "Maya Salsabila",
            email: "maya.salsabila@ekozer.co.id",
            department: "HR",
            position: "Learning & Development Specialist",
            skills: [
                SkillRecord(id: "sk14", skillName: "Learning Design", category: "HR", type: .hardSkill, level: .expert),
                SkillRecord(id: "sk15", skillName: "Facilitation", category: "People", type: .softSkill, level: .expert),
                SkillRecord(id: "sk16", skillName: "Coaching", category: "People", type: .softSkill, level: .advanced),
                SkillRecord(id: "sk17", skillName: "Talent Mapping", category: "HR", type: .hardSkill, level: .advanced)
            ],
            certifications: [
                CertificationRecord(id: "cert5", title: "Certified Trainer", issuer: "BNP", yearText: "2023")
            ],
            projectExperience: [
                ProjectExperienceRecord(id: "exp5", projectName: "Technical Academy Rollout", role: "Program Owner", summary: "Membangun learning path untuk supervisor site.", yearText: "2025")
            ],
            careerInterest: ["Talent Management", "Organizational Development"],
            createdAt: "08 Apr 2025",
            updatedAt: "15 Mar 2026"
        )
    ]

    static let internalProjects: [InternalProject] = [
        InternalProject(
            id: "ip1",
            projectId: "PRJ-2601",
            projectTitle: "Attendance Analytics Dashboard",
            description: "Membangun dashboard internal untuk melihat tren kehadiran, lembur, dan potensi skill gap lintas departemen.",
            businessUnit: "HRIS",
            projectOwner: "Maya Salsabila",
            duration: "10 Weeks",
            requiredSkills: [
                ProjectSkillRequirement(id: "req1", skillName: "Power BI", minimumLevel: .intermediate),
                ProjectSkillRequirement(id: "req2", skillName: "SQL", minimumLevel: .intermediate),
                ProjectSkillRequirement(id: "req3", skillName: "Stakeholder Communication", minimumLevel: .intermediate)
            ],
            workload: "6 jam / minggu",
            status: .open,
            applicants: [
                ProjectApplicant(id: "app1", employeeId: "0000000731", fullName: "Rizky Ramadhan", department: "Operations", position: "Production Engineer", skillMatch: 92, matchingSkills: ["Power BI", "SQL"], appliedAt: "13 Mar 2026", note: "Siap support kebutuhan dashboard operasional.")
            ],
            selectedMembers: [],
            createdAt: "01 Mar 2026",
            updatedAt: "15 Mar 2026"
        ),
        InternalProject(
            id: "ip2",
            projectId: "PRJ-2602",
            projectTitle: "Internal Asset Tracking Revamp",
            description: "Merapikan pelacakan aset site dan HO agar transfer aset lebih transparan dan cepat dipantau.",
            businessUnit: "IT Support",
            projectOwner: "Eko Ardianto",
            duration: "8 Weeks",
            requiredSkills: [
                ProjectSkillRequirement(id: "req4", skillName: "Asset Management", minimumLevel: .advanced),
                ProjectSkillRequirement(id: "req5", skillName: "Problem Solving", minimumLevel: .advanced),
                ProjectSkillRequirement(id: "req6", skillName: "Excel", minimumLevel: .intermediate)
            ],
            workload: "4 jam / minggu",
            status: .inProgress,
            applicants: [
                ProjectApplicant(id: "app2", employeeId: "0000000583", fullName: "Eko Ardianto", department: "IT Support", position: "IT Support Officer", skillMatch: 96, matchingSkills: ["Asset Management", "Problem Solving"], appliedAt: "10 Mar 2026", note: "Sudah pernah mengelola inventaris site support.")
            ],
            selectedMembers: ["0000000583"],
            createdAt: "24 Feb 2026",
            updatedAt: "12 Mar 2026"
        ),
        InternalProject(
            id: "ip3",
            projectId: "PRJ-2603",
            projectTitle: "Data Analyst Career Sprint",
            description: "Program cross-functional untuk membentuk mini squad analitik bisnis dari talent internal.",
            businessUnit: "Corporate Strategy",
            projectOwner: "Nadia Permata",
            duration: "12 Weeks",
            requiredSkills: [
                ProjectSkillRequirement(id: "req7", skillName: "SQL", minimumLevel: .intermediate),
                ProjectSkillRequirement(id: "req8", skillName: "Data Visualization", minimumLevel: .intermediate),
                ProjectSkillRequirement(id: "req9", skillName: "Problem Solving", minimumLevel: .advanced)
            ],
            workload: "5 jam / minggu",
            status: .open,
            applicants: [],
            selectedMembers: [],
            createdAt: "05 Mar 2026",
            updatedAt: "15 Mar 2026"
        )
    ]

    static let aiSuggestedQuestions: [String] = [
        "Berapa sisa cuti saya?",
        "Bagaimana cara reimbursement?",
        "Skill apa yang harus saya pelajari untuk menjadi Data Analyst?",
        "Apakah ada proyek internal yang cocok dengan skill saya?"
    ]

    static let aiMessages: [AIHRChatMessage] = [
        AIHRChatMessage(
            id: "ai1",
            role: .assistant,
            text: "Halo, saya siap bantu pertanyaan HR Anda. Saya juga bisa memberi rekomendasi skill dan proyek internal berdasarkan data skill inventory.",
            timestamp: "09:00",
            highlights: ["Cuti", "Payroll", "Reimbursement", "Career Growth"]
        )
    ]

    private static func date(daysAgo: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
    }
}
