//
//  SupabaseService.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import Foundation
import Supabase

// -> It is not okay to have hardcoded keys on the project. The ideal approach is to store secrets safely on the backend

enum SupabaseService {
    static let client = SupabaseClient(
        supabaseURL: URL(string: "https://twufovqjvmshixvuwden.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR3dWZvdnFqdm1zaGl4dnV3ZGVuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkwMTUyMjgsImV4cCI6MjA4NDU5MTIyOH0.9vOLguZECp7uMfR-CbWF6gPwagkVjGqxeucNg1yU56w"
        
    )
}


