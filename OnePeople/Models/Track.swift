import Foundation

enum OnePeopleFeature: String, CaseIterable, Identifiable, Hashable {
    case attendance = "Absensi"
    case approval = "Approval"
    case asset = "Aset"
    case leave = "Izin"
    case attendanceReport = "Laporan Kehadiran"
    case roster = "Roster"
    case payslip = "Slip Gaji"
    case skillInventory = "Skill Inventory"
    case projectMarketplace = "Project Marketplace"
    case aiAssistant = "AI HR Assistant"

    var id: String { rawValue }
}

enum AttendanceActionMode: String, Identifiable, Hashable {
    case checkIn = "Check In"
    case checkOut = "Check Out"

    var id: String { rawValue }

    var buttonTitle: String {
        switch self {
        case .checkIn:
            return "CHECK IN"
        case .checkOut:
            return "CHECK OUT"
        }
    }

    var selfieTitle: String {
        switch self {
        case .checkIn:
            return "Ambil Selfie Check In"
        case .checkOut:
            return "Ambil Selfie Check Out"
        }
    }
}

struct EmployeeProfile {
    let employeeID: String
    let fullName: String
    let role: String
    let department: String
    let company: String
    let location: String
    let manager: String
    let email: String
    let phone: String
    let shift: String
    let annualLeaveBalance: Int
}

struct DashboardMetric: Identifiable {
    let id: String
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let colorHex: String
}

struct Announcement: Identifiable {
    let id: String
    let title: String
    let message: String
    let dateText: String
    let category: String
}

struct AttendanceRecord: Identifiable, Hashable {
    let id: String
    let date: Date
    let checkIn: String
    let checkOut: String
    let workHours: String
    let status: AttendanceStatus
    let location: String
}

enum AttendanceStatus: String, CaseIterable {
    case present = "Present"
    case late = "Late"
    case remote = "Remote"
    case dayOff = "Day Off"

    var iconName: String {
        switch self {
        case .present:
            return "checkmark.circle.fill"
        case .late:
            return "clock.badge.exclamationmark.fill"
        case .remote:
            return "desktopcomputer"
        case .dayOff:
            return "bed.double.fill"
        }
    }
}

struct LeaveRequest: Identifiable, Hashable {
    let id: String
    let title: String
    let type: String
    let startDateText: String
    let endDateText: String
    let durationText: String
    let reason: String
    var status: RequestStatus
}

struct ApprovalItem: Identifiable, Hashable {
    let id: String
    let requester: String
    let title: String
    let detail: String
    let submittedAt: String
    var status: RequestStatus
}

enum RequestStatus: String, CaseIterable {
    case approved = "Approved"
    case pending = "Pending"
    case rejected = "Rejected"

    var iconName: String {
        switch self {
        case .approved:
            return "checkmark.seal.fill"
        case .pending:
            return "hourglass.circle.fill"
        case .rejected:
            return "xmark.octagon.fill"
        }
    }
}

struct Payslip: Identifiable, Hashable {
    let id: String
    let month: String
    let payDate: String
    let grossSalary: String
    let deductions: String
    let takeHomePay: String
}

struct ServiceMenu: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
}

struct HomeShortcut: Identifiable {
    let id: String
    let title: String
    let icon: String
    let tintHex: String
    let backgroundHex: String
    let feature: OnePeopleFeature?
}

struct ProfileMenuItem: Identifiable {
    let id: String
    let title: String
    let icon: String
}

struct SettingsItem: Identifiable {
    let id: String
    let title: String
    let icon: String
    let showsToggle: Bool
}

struct MessageItem: Identifiable {
    let id: String
    let sender: String
    let subject: String
    let preview: String
    let time: String
}

struct AttendanceSelfieAudit: Identifiable {
    let id: String
    let mode: AttendanceActionMode
    let capturedAtText: String
    let note: String
}

struct AttendanceTimelineEntry: Identifiable {
    let id: String
    let dateLabel: String
    let checkInText: String
    let checkOutText: String
    let location: String
}

struct AttendanceReportRow: Identifiable {
    let id: String
    let dayLabel: String
    let checkIn: String
    let checkOut: String
    let overtime: String
    let dt: String
    let pc: String
    let isRosterOff: Bool
}

enum CalendarDayState: String, Hashable {
    case present
    case off
    case missing
}

struct CalendarDayMarker: Identifiable {
    let id: String
    let day: Int
    let state: CalendarDayState
}

struct AssetRecord: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let unitText: String
    let icon: String
    let tintHex: String
}

struct AssetTransferRecord: Identifiable {
    let id: String
    let title: String
    let detail: String
    let dateText: String
}

struct PayrollLineItem: Identifiable {
    let id: String
    let title: String
    let amount: String
}

struct PayrollSection: Identifiable {
    let id: String
    let title: String
    let icon: String
    let tintHex: String
    let lines: [PayrollLineItem]
    let totalLabel: String
    let totalAmount: String
    let totalTintHex: String
}

enum SkillProficiencyLevel: String, CaseIterable, Identifiable, Hashable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"

    var id: String { rawValue }

    var rank: Int {
        switch self {
        case .beginner:
            return 1
        case .intermediate:
            return 2
        case .advanced:
            return 3
        case .expert:
            return 4
        }
    }

    var tintHex: String {
        switch self {
        case .beginner:
            return "#64748B"
        case .intermediate:
            return "#2AA6BA"
        case .advanced:
            return "#1D4ED8"
        case .expert:
            return "#7C3AED"
        }
    }
}

enum EmployeeSkillType: String, CaseIterable, Identifiable, Hashable {
    case hardSkill = "Hard Skill"
    case softSkill = "Soft Skill"

    var id: String { rawValue }
}

struct SkillRecord: Identifiable, Hashable {
    let id: String
    let skillName: String
    let category: String
    let type: EmployeeSkillType
    let level: SkillProficiencyLevel
}

struct CertificationRecord: Identifiable, Hashable {
    let id: String
    let title: String
    let issuer: String
    let yearText: String
}

struct ProjectExperienceRecord: Identifiable, Hashable {
    let id: String
    let projectName: String
    let role: String
    let summary: String
    let yearText: String
}

struct EmployeeSkillProfile: Identifiable, Hashable {
    let id: String
    let employeeId: String
    let fullName: String
    let email: String
    let department: String
    let position: String
    var skills: [SkillRecord]
    let certifications: [CertificationRecord]
    let projectExperience: [ProjectExperienceRecord]
    let careerInterest: [String]
    let createdAt: String
    var updatedAt: String
}

enum InternalProjectStatus: String, CaseIterable, Identifiable, Hashable {
    case open = "Open"
    case inProgress = "In Progress"
    case closed = "Closed"

    var id: String { rawValue }

    var tintHex: String {
        switch self {
        case .open:
            return "#2AA6BA"
        case .inProgress:
            return "#D97706"
        case .closed:
            return "#64748B"
        }
    }
}

struct ProjectSkillRequirement: Identifiable, Hashable {
    let id: String
    let skillName: String
    let minimumLevel: SkillProficiencyLevel
}

struct ProjectApplicant: Identifiable, Hashable {
    let id: String
    let employeeId: String
    let fullName: String
    let department: String
    let position: String
    let skillMatch: Int
    let matchingSkills: [String]
    let appliedAt: String
    let note: String
}

struct InternalProject: Identifiable, Hashable {
    let id: String
    let projectId: String
    var projectTitle: String
    var description: String
    var businessUnit: String
    var projectOwner: String
    var duration: String
    var requiredSkills: [ProjectSkillRequirement]
    var workload: String
    var status: InternalProjectStatus
    var applicants: [ProjectApplicant]
    var selectedMembers: [String]
    let createdAt: String
    var updatedAt: String
}

enum AIHRMessageRole: String, Hashable {
    case user
    case assistant
}

struct AIHRChatMessage: Identifiable, Hashable {
    let id: String
    let role: AIHRMessageRole
    let text: String
    let timestamp: String
    let highlights: [String]
}
