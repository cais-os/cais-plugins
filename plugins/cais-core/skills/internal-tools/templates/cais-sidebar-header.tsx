"use client"

import {
  Check,
  ChevronsUpDown,
  PenLine,
  Radar,
  Zap,
  type LucideIcon,
} from "lucide-react"

import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import {
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "@/components/ui/sidebar"

interface CaisApp {
  name: string
  description: string
  url: string
  icon: LucideIcon
}

// TODO: Update URLs and icons to match your deployed apps.
// Add or remove entries as new products launch.
const CAIS_APPS: CaisApp[] = [
  {
    name: "Farol",
    description: "Market research",
    url: "https://farol.cais.dev",
    icon: Radar,
  },
  {
    name: "Flow",
    description: "Messaging automation",
    url: "https://flow.cais.dev",
    icon: Zap,
  },
  {
    name: "Content",
    description: "Content generation",
    url: "https://content.cais.dev",
    icon: PenLine,
  },
]

export function CaisSidebarHeader({
  appName,
  appIcon: AppIcon,
}: {
  appName: string
  appIcon: LucideIcon
}) {
  return (
    <SidebarHeader>
      <SidebarMenu>
        <SidebarMenuItem>
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <SidebarMenuButton
                size="lg"
                className="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
              >
                <div className="flex aspect-square size-8 items-center justify-center rounded-lg bg-sidebar-primary text-sidebar-primary-foreground">
                  <AppIcon className="size-4" />
                </div>
                <div className="flex flex-col gap-0.5 leading-none">
                  <span className="font-medium">Cais {appName}</span>
                  <span className="text-xs text-muted-foreground">
                    Suite
                  </span>
                </div>
                <ChevronsUpDown className="ml-auto" />
              </SidebarMenuButton>
            </DropdownMenuTrigger>
            <DropdownMenuContent
              className="w-(--radix-dropdown-menu-trigger-width)"
              align="start"
            >
              {CAIS_APPS.map((app) => {
                const isCurrent = app.name === appName

                return (
                  <DropdownMenuItem key={app.name} asChild={!isCurrent}>
                    {isCurrent ? (
                      <span>
                        <app.icon className="mr-2 size-4" />
                        Cais {app.name}
                        <Check className="ml-auto size-4" />
                      </span>
                    ) : (
                      <a href={app.url}>
                        <app.icon className="mr-2 size-4" />
                        Cais {app.name}
                      </a>
                    )}
                  </DropdownMenuItem>
                )
              })}
            </DropdownMenuContent>
          </DropdownMenu>
        </SidebarMenuItem>
      </SidebarMenu>
    </SidebarHeader>
  )
}
