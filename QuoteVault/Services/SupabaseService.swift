//
//  SupabaseService.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://twufovqjvmshixvuwden.supabase.co")!,
    supabaseKey: "YeyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR3dWZvdnFqdm1zaGl4dnV3ZGVuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkwMTUyMjgsImV4cCI6MjA4NDU5MTIyOH0.9vOLguZECp7uMfR-CbWF6gPwagkVjGqxeucNg1yU56w"
)
